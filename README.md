# Blockchain in E-Learning Platform to Enhance Trustworthy and Sharing of Micro-Credentials

This project contains "demonstration" smart contracts to integrate a consortium blockchain within e-learning platform to improve the verifiability, trustworthy and sharing of micro-credentials certificates.

## Smart Contracts Description

The smart contracts have the structure illustrated in the following picture.
![alt text](https://github.com/alessandrobigiotti/micro-credentials-smart-contracts/blob/main/img/smartcontracttree.png?raw=true)

The only access point to the blockchain is the ELearningPlatform smart contract. This smart contract has the task to manage all other smart contracts dynamically.

The main functions contained in the ELearningPlatform.sol are:
- ```registerInstitution```: this function is in charge of creating a new Institution within the platform. An institution that want to be registered in the platform must provide its name, its address, its country and its  postcode. The platform will generate a pair of keys (one public and one private) associated to the institution and its id. Then, the function will append the address of the new smart contract to the ```institutionsList```, and the public key to ```institutionKeys```. The latter allows an institution to operate within the platform.
- ```registerCandidate```: this function allows to register a new candidate within the platform. The sensible data about a user will be stored off-chain within the platform and only a unique identifier (```candidateID```) will be stored in the blockchain. Then the function will append the address of the new smart contract to the ```candidateList```.
- ```registerCourse```: This function allows an institution to create a new course. If the checks are satisfied, this function will invoke an external call to the Institution smart contract. This external call will create a new Course smart contract and will register the new smart within the Institution smart contract. The addresses of the course smart contracts are stored within an array ```coursesContarcts```. Each smart contract institution holds the list of its courses.
- ```courseSubscription```: This function enrols a candidate to a course. To do so, the function will invoke an external call to the Candidate smart contract that update the list of courses attended by the specific candidate.
- ```passCourse```: This function sets the status of a course to passed. It allows to certify that a candidate has correctly passed the course where it was enrolled.
- ```checkExam```: This function allows to verify the status of a course. It requires the candidate ID, the institution ID and the course ID and returns a boolean value that is: true if the course is passed by the candidate, false otherwise.

### Functions permissioning

To test smart contracts it is necessary to specify the addresses of the various actors. To this end, the only smart contract with which you can interact is the ```ELearningPlatform.sol``` smart contract. To interact with this smart contract you need:
  1. the address of the account that deployed it (the owner). Using this address is it possible to register new institutions and / or new Candidates.
  2. the address of the particular institution. Using the address provided during the registration of an institution, it is possible to add new courses or enrol candidates in the courses it provides.

All the other smart contracts can be modify only by the root smart contract.
​


## Project Configuration

In order to correctly deploy smart contracts, the truffle.js file must be configured by specifying the private key of the account responsible for the deployments in the blockchain (privateKey: it must be the owner account of the ELearningPlatform smart contract). Once this is done, you must specify the blockchain on which you want to deploy. To do so, it is necessary to indicate the chain ID, the gas to be used, the connection URL and the address (it must relate to the private key specified above).

To allow the deployment of [EVM contract in Fabric](https://archive.trufflesuite.com/docs/truffle/how-to/distributed-ledger-support/hyperledger-evm/), it is needed to specify

### Install node modules

After the configuration is done, it is necessary to install all node modules and dependencies. To do so, type from the main directory:
```
$ npm install
```
If the installation ends correctly, it is possible to deploy the smart contracts under the contracts folder by executing the *compileDeployContracts.sh* under the scripts folder.

The configuration of the Hyperleder Besu and Hypereldger Fabric goes beyond the purpose of this repository. The reader intended to deploy and test the smart contracts on different platforms can follow the approprite guide [Hyperledger Besu](https://besu.hyperledger.org/23.4.0/private-networks), and [Hyperledger Fabric](https://github.com/hyperledger-archives/fabric-chaincode-evm) for [evm contracts deployment](https://archive.trufflesuite.com/docs/truffle/how-to/distributed-ledger-support/hyperledger-evm/) 


***NOTICE***: If you want to deploy and tests the smart contracts on [Remix](https://remix.ethereum.org) you can create a folder containing all the smart contracts under the contracts folder of this repository. The only smart contract you need to deploy is the *ELearningPlatform.sol* smart contract. Maybe you need to force the deploy as the *ELearningPlatform.sol* bytecode exceeds the maximum dimension allowed by Etherem public blockchain.
