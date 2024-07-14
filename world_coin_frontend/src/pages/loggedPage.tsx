// import { useState } from 'react';
import styles from '../styles/loggingPage.module.css';
import { useRouter } from 'next/router';
// import { createWalletClientFromWallet, useDynamicContext } from '@dynamic-labs/sdk-react-core';
// import {
//   approveERC20,
//   crossChainTransferERC20,
//   getPimlicoSmartAccountClient,
//   transferERC20,
// } from "~~/lib/permissionless";
// import { useAccount, useBalance, useReadContract } from "wagmi";

const LoggedPage = () => {
  // const [error, setError] = useState<string | null>(null);
  // const [loading, setLoading] = useState(false);
  // const { primaryWallet, isAuthenticated } = useDynamicContext();
  // const { address, chain, isConnected } = useAccount();

    const router = useRouter();
    const { nullifierHash } = router.query; // Retrieve the nullifierHash from query parameters
  //   const handleERC20Transfer = async () => {
      
  //     setLoading(true);
  //     setError(null);
  //     try {
  //       const userAddress = address as `0x${string}`;
  //       if (!primaryWallet || !chain) return;
  //       const walletClient = await createWalletClientFromWallet(primaryWallet);
  //       const smartAccountClient = await getPimlicoSmartAccountClient(userAddress, chain, walletClient);
  //       const txHash = await transferERC20(
  //         smartAccountClient,
  //         transferTokenAddress,
  //         BigInt(transferAmount * 10 ** 6),
  //         recipientAddress,
  //       );
  
  //       notification.success("Crosschain transfer initiated successfully: " + txHash);
  //       console.log("txHash", txHash);
  //       setTransactions([...transactions, txHash]);
  //       const transactionDetail = await getTransactionOnBaseSepoliaByHash(txHash);
  //       setTransactionDetails([...transactionDetails, transactionDetail]);
  //     } catch (err) {
  //       setError("Failed to transfer tokens.");
  //       console.error(err);
  //     } finally {
  //       setLoading(false);
  //     }
  //   };
    return (
      
      <div className={styles.container}>
      <div className={styles.content}>
        <div className={styles.title}>
          <h1>LOCK</h1>
          <p className={styles.subtitle}>Secure your transaction with our powerful worldcoin encryption.</p>
        </div>
        {nullifierHash && <p className="text-md mt-4">Your Nullifier Hash: {nullifierHash}</p>}

        {/* <div className={styles.inputContainer}>
          <input
            type="text"
            placeholder="Enter your secret message"
            className={styles.inputField}
          />
          <CiLock className={styles.icon} />
        </div> */}
      </div>
    </div>
    );
  };
  
  export default LoggedPage;

