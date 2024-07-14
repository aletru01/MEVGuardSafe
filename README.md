# Gnosis Safe Module: Risk Assessment with Chainalysis Oracle and Worldcoin Authentication

This project aims to develop a new module for the Gnosis Safe smart account system, following the ERC-7579 standard. The module focuses on providing risk assessment tools for DeFi platforms, leveraging the Chainalysis oracle for sanctions screening. Additionally, the application integrates Worldcoin authentication to ensure secure user identification before accessing the wallet and performing transactions.

## Features

- Compliance with the ERC-7579 standard, ensuring compatibility with smart account implementations supporting the standard.
- Risk assessment functionality for DeFi platforms, allowing users to evaluate the risk level associated with various platforms.
- Integration with the Chainalysis oracle for sanctions screening, validating if a cryptocurrency wallet address has been included in a sanctions designation.
- User identification through Worldcoin authentication, enhancing security by verifying user identity before granting access to the wallet and enabling safe transactions.

## Architecture

The module consists of the following key components:

1. **ERC-7579 Compliance**: The module is built in accordance with the ERC-7579 standard, ensuring seamless integration with smart account implementations that support this standard.

2. **Risk Assessment Engine**: The module includes a risk assessment engine that evaluates the risk level of various DeFi platforms. It analyzes relevant data and provides insights to help users make informed decisions.

3. **Chainalysis Oracle Integration**: The module integrates with the Chainalysis oracle, a smart contract that validates if a cryptocurrency wallet address has been included in a sanctions designation. This integration ensures compliance with regulatory requirements and helps prevent interactions with sanctioned addresses.

4. **Worldcoin Authentication**: The application leverages Worldcoin authentication to verify user identity before granting access to the wallet. This additional layer of security ensures that only authenticated users can perform safe transactions.

## Installation and Setup

To set up the Gnosis Safe Module with Risk Assessment and Worldcoin Authentication, follow these steps: 

1. Clone the repository:

`git clone git@github.com:aletru01/SafeRisk.git`

2. Install the required dependencies:
npm install

3. Configure the necessary environment variables, including the Chainalysis oracle address and Worldcoin authentication details.

4. Deploy the module to the desired blockchain network.

5. Integrate the module with your Gnosis Safe smart account implementation.

## Usage

Once the module is set up and integrated with your Gnosis Safe account, users can access the risk assessment functionality and perform safe transactions. The application will guide users through the Worldcoin authentication process before allowing access to the wallet.

To assess the risk level of a DeFi platform:

1. Navigate to the risk assessment section of the application.
2. Select the desired DeFi platform from the available options.
3. Review the risk assessment results provided by the module.

To perform a safe transaction:

1. Authenticate using Worldcoin to verify your identity.
2. Access your Gnosis Safe wallet.
3. Initiate a transaction, specifying the recipient address and the amount.
4. The module will validate the recipient address against the Chainalysis oracle to ensure it is not included in a sanctions designation.
5. If the validation passes, the transaction will be executed securely.

## Contributing

We welcome contributions to enhance the functionality and security of the Gnosis Safe Module with Risk Assessment and Worldcoin Authentication. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and ensure that the code passes all tests.
4. Submit a pull request, describing your changes in detail.

Please adhere to the project's coding conventions and guidelines.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

If you have any questions, suggestions, or feedback, please contact us at [email@example.com](mailto:email@example.com).

We appreciate your interest in the Gnosis Safe Module with Risk Assessment and Worldcoin Authentication. Happy safe transacting

