# Sample Hardhat Project- Web3bridge Eviction Test

Write a smart contract that does anything you want and must implement a Factory contract, deploy it to a testnet (Sepolia or Mumbai) and also use a hardhat script to interact with a write function in your smart contract. Copy and paste the transaction hash inside your script file and push your project to Github(excluding the ones written in class)

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

FundingFactory is the factory contract responsible for deploying new Funding campaigns.
FundingCampaign is the individual campaign contract handling the fundraising for a specific project.
Investors can contribute to a campaign by calling the contribute function.
If a campaign reaches its funding goal before the deadline, it succeeds. Otherwise, it fails.
The campaign creator can withdraw the funds raised if the campaign succeeds.
There's a function checkCampaignStatus to check the current status of a campaign.
This demonstrates how a factory contract can be used to deploy and manage individual contracts for different purposes, in this case, Funding campaigns.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
