# Consortium Blockchain in E-Learning Platform to Improve Verifiability, Trustworthy and Sharing of Micro-Credentials

This project contains "demonstration" smart contracts to integrate a consortium blockchain within e-learning platform to improve the verifiability, trustworthy and sharing of micro-credentials certificates.

## Smart Contracts Description

The smart contracts have the structure illustrated in the following picture.
![alt text](https://github.com/alessandrobigiotti/micro-credentials-smart-contracts/blob/main/img/smartcontracttree.png?raw=true)

The only access point to the blockchain is the ELearningPlatform smart contract. This smart contract has the task to manage all other smart contracts dynamically.


## Project Configuration

In order to correctly deploy smart contracts, the truffle.js file must be configured by specifying the private key of the account responsible for the deployments in the blockchain (privateKey: it must be the owner account of the ELearningPlatform smart contract). Once this is done, you must specify the blockchain on which you want to deploy. To do so, it is necessary to indicate the chain ID, the gas to be used, the connection URL and the address (it must relate to the private key specified above).

### Install node modules

After the configuration is done, it is necessary to install all node modules and dependencies. To do so, type from the main directory:
```
$ npm install
```
If the installation ends correctly, it is possible to deploy the smart contracts under the contracts folder by executing the *compileDeployContracts.sh* under the scripts folder.

***NOTICE***: If you want to deploy and tests the smart contracts on [Remix](https://remix.ethereum.org) you can create a folder containing all the smart contracts under the contracts folder of this repository. The only smart contract you need to deploy is the *ELearningPlatform.sol* smart contract.
