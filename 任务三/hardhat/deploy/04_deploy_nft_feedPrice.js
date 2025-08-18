const{deployments,upgrades,ethers}=require("hardhat");
const fs=require("fs");
const path=require("path");
// ["0x694AA1769357215DE4FAC081bf1f309aDC325306"] // Sepolia ETH/USD Chainlink Feed Address
module.exports = async ({getNamedAccounts, deployments})=>{
    const {save} = deployments;
    // const {deployer} = await getNamedAccounts();
    // console.log("部署用户地址-------",deployer);
    const [deployer] = await ethers.getSigners();
    console.log("Deploying auction system with the account:", deployer.address);
    
    // 1.部署价格预言机
    const FeedPrice = await ethers.getContractFactory("FeedPrice");
    const feedPrice = await FeedPrice.deploy();
    feedPrice.waitForDeployment();
    // 获取ETH/USD价格预言机地址
    const feedPriceAddress = await feedPrice.getAddress();
    console.log("FeedPrice deployed to:", feedPriceAddress);
    saveDeploymentInfo(feedPriceAddress, deployer.address);
  
        // console.log("部署信息已保存-------",storePath);
        // // 4.保存到hardhat-deploy的部署记录中
        // await save("AuctionProxy", {
        //     address: proxyAddress,
        //     abi: auction.interface.format("json")
        // });

};
// 保存部署信息
function saveDeploymentInfo(contractAddress, deployerAddress) {
  const deploymentDir = path.join(__dirname, "../deployments");
  if (!fs.existsSync(deploymentDir)) {
    fs.mkdirSync(deploymentDir);
  }

  const deploymentInfo = {
    contract: "FeedPrice",
    address: contractAddress,
    deployer: deployerAddress,
    network: network.name,
    timestamp: new Date().toISOString(),
    blockNumber: FeedPrice.deployTransaction.blockNumber,
    transactionHash: FeedPrice.deployTransaction.hash
  };

  const filePath = path.join(deploymentDir, `feed-price-${network.name}.json`);
  fs.writeFileSync(filePath, JSON.stringify(deploymentInfo, null, 2));
  console.log(`部署信息已保存到 ${filePath}`);
}
module.exports.tags = ["deployFeedPrice"];