// import { ethers } from "hardhat";

// async function main() {
//   const [deployer] = await ethers.getSigners();

//   const factoryAddress = "0x85271cb4A12a0BB18c82c5BC7d7F8752B68b79cE"; 

//   const CrowdfundingFactory = await ethers.getContractFactory("FundingFactory");
//   const crowdfundingFactory = await CrowdfundingFactory.attach(factoryAddress);

//   // Create a new crowdfunding campaign
//   const goalAmount = ethers.parseEther("10"); // 10 ether
//   const deadline = Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 30); // 30 days from now

//   const tx = await crowdfundingFactory.createCampaign(goalAmount, deadline);
//   await tx.wait();

//   console.log("New funding campaign created.");
// }

// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });
