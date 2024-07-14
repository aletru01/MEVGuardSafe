// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC7579HookDestruct } from "modulekit/Modules.sol";
import { Execution } from "modulekit/external/ERC7579.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";

interface IChainalysisSanctionsList {
    function isSanctioned(address addr) external view returns (bool);
    function isSanctionedVerbose(address addr) external returns (bool);
    function name() external pure returns (string memory);
}

contract RiskAssessmentHook is ERC7579HookDestruct {
    /*//////////////////////////////////////////////////////////////////////////
                                     STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    address public constant SANCTIONS_CONTRACT = 0x6683A643912A76850BEF11eBd79b99c71D247722; //sepolia
    IChainalysisSanctionsList public sanctionsList;

    bool public useVerboseChecking;
    mapping(address => bool) public whitelistedAddresses;
    uint256 public frozenBalance; // New state variable to track frozen ETH

    event RiskAssessmentPerformed(address indexed target, bool isSanctioned);
    event FrozenBalanceUpdated(uint256 newFrozenBalance); // New event for frozen balance updates

    /*//////////////////////////////////////////////////////////////////////////
                                     CONFIG
    //////////////////////////////////////////////////////////////////////////*/

    constructor() {
        sanctionsList = IChainalysisSanctionsList(SANCTIONS_CONTRACT);
    }

    function onInstall(bytes calldata data) external override {
        (bool _useVerboseChecking, address[] memory _whitelistedAddresses) = abi.decode(data, (bool, address[]));
        useVerboseChecking = _useVerboseChecking;
        for (uint i = 0; i < _whitelistedAddresses.length; i++) {
            whitelistedAddresses[_whitelistedAddresses[i]] = true;
        }
    }

    function onUninstall(bytes calldata) external override {
        // Reset configuration
        useVerboseChecking = false;
        // Note: We're not clearing the whitelist as it might be gas-intensive.
        // If needed, this could be done in batches or left to the contract's destruction.
    }

    function isInitialized(address) external view returns (bool) {
        // Consider the module initialized if the sanctionsList is set
        return address(sanctionsList) != address(0);
    }

    function setUseVerboseChecking(bool _useVerboseChecking) external {
        useVerboseChecking = _useVerboseChecking;
    }

    function addToWhitelist(address[] calldata addresses) external {
        for (uint i = 0; i < addresses.length; i++) {
            whitelistedAddresses[addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] calldata addresses) external {
        for (uint i = 0; i < addresses.length; i++) {
            whitelistedAddresses[addresses[i]] = false;
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     MODULE LOGIC
    //////////////////////////////////////////////////////////////////////////*/

    function _checkSanctions(address target) internal returns (bool) {
        if (whitelistedAddresses[target]) {
            return false;
        }

        bool isSanctioned;
        if (useVerboseChecking) {
            isSanctioned = sanctionsList.isSanctionedVerbose(target);
        } else {
            isSanctioned = sanctionsList.isSanctioned(target);
        }

        emit RiskAssessmentPerformed(target, isSanctioned);
        
        if (isSanctioned) {
            revert("RiskAssessmentHook: Transfer to sanctioned address");
        }
        
        return isSanctioned;
    }

    function _updateFrozenBalance(address sender, uint256 value) internal {
        if (_checkSanctions(sender)) {
            frozenBalance += value;
            emit FrozenBalanceUpdated(frozenBalance);
        }
    }

    function getAvailableBalance() public view returns (uint256) {
        return address(this).balance - frozenBalance;
    }

    function onExecute(
        address,
        address sender,
        address target,
        uint256 value,
        bytes calldata callData
    )
        internal
        override
        returns (bytes memory)
    {
        if (value > 0) {
            _updateFrozenBalance(sender, value);
        }

        _checkSanctions(target);
        if (callData.length >= 4) {
            bytes4 selector = bytes4(callData[:4]);
            if (selector == IERC20.transfer.selector) {
                (address to, uint256 amount) = abi.decode(callData[4:], (address, uint256));
                _checkSanctions(to);
            } else if (selector == bytes4(keccak256("transfer(address)"))) {
                // Assuming this is an ETH transfer
                require(value <= getAvailableBalance(), "RiskAssessmentHook: Insufficient available balance");
            }
        }
        return "";
    }

    function onExecuteBatch(
        address,
        address sender,
        Execution[] calldata executions
    )
        internal
        override
        returns (bytes memory)
    {
        uint256 totalValue = 0;
        for (uint256 i = 0; i < executions.length; i++) {
            if (executions[i].value > 0) {
                totalValue += executions[i].value;
            }
            _checkSanctions(executions[i].target);
            if (executions[i].callData.length >= 4) {
                bytes4 selector = bytes4(executions[i].callData[:4]);
                if (selector == IERC20.transfer.selector) {
                    (address to,) = abi.decode(executions[i].callData[4:], (address, uint256));
                    _checkSanctions(to);
                } else if (selector == bytes4(keccak256("transfer(address)"))) {
                    // Assuming this is an ETH transfer
                    require(executions[i].value <= getAvailableBalance(), "RiskAssessmentHook: Insufficient available balance");
                }
            }
        }
        if (totalValue > 0) {
            _updateFrozenBalance(sender, totalValue);
        }
        return "";
    }

    function onExecuteFromExecutor(
        address,
        address,
        address target,
        uint256,
        bytes calldata callData
    )
        internal
        override
        returns (bytes memory)
    {
        _checkSanctions(target);
        if (callData.length >= 4 && bytes4(callData[:4]) == IERC20.transfer.selector) {
            (address to,) = abi.decode(callData[4:], (address, uint256));
            _checkSanctions(to);
        }
        return "";
    }

    function onExecuteBatchFromExecutor(
        address,
        address,
        Execution[] calldata executions
    )
        internal
        override
        returns (bytes memory)
    {
        for (uint256 i = 0; i < executions.length; i++) {
            _checkSanctions(executions[i].target);
            if (executions[i].callData.length >= 4 && bytes4(executions[i].callData[:4]) == IERC20.transfer.selector) {
                (address to,) = abi.decode(executions[i].callData[4:], (address, uint256));
                _checkSanctions(to);
            }
        }
        return "";
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     METADATA
    //////////////////////////////////////////////////////////////////////////*/

    function name() external view returns (string memory) {
        return string(abi.encodePacked("RiskAssessmentHook-", sanctionsList.name()));
    }

    function version() external pure returns (string memory) {
        return "1.1.0";
    }

    function isModuleType(uint256 typeID) external pure override returns (bool) {
        return typeID == TYPE_HOOK;
    }
}