const{deployments,upgrades,ethers}=require("hardhat");
const fs=require("fs");
const path=require("path");
// ["0x694AA1769357215DE4FAC081bf1f309aDC325306"] // Sepolia ETH/USD Chainlink Feed Address
const ETH_USD_PRICE_FEED_ADDRESS = "0x694AA1769357215DE4FAC081bf1f309aDC325306";
module.exports = async ({getNamedAccounts, deployments})=>{
    const { deployer } = await getNamedAccounts();

    console.log("Deploying auction system with the account:", deployer);

    // 1.部署拍卖实现合约
    const Auction = await ethers.getContractFactory("Auction");
    const auctionImplementation = await Auction.deploy();
    auctionImplementation.waitForDeployment();
    const auctionImplementationAddress = await auctionImplementation.getAddress();
    console.log("Auction implementation deployed to:", auctionImplementationAddress);
    // 2.部署拍卖工厂
    const AuctionFactory = await ethers.getContractFactory("AuctionFactory");
    //const auctionFactory = await AuctionFactory.deploy(auctionImplementation.address);
    const auctionFactory = await upgrades.deployProxy(
        AuctionFactory, 
        [auctionImplementationAddress, ETH_USD_PRICE_FEED_ADDRESS], {
        initializer: "initialize",
        kind: "transparent"
    });
    auctionFactory.waitForDeployment();
    // 获取拍卖工厂地址 
    const auctionFactoryAddress = await auctionFactory.getAddress();
    console.log("AuctionFactory deployed to:", auctionFactoryAddress);
    // 3.保存部署信息
    // const storePath = path.join(__dirname,"./.cache/proxyAuction.json");
    // fs.writeFileSync(storePath,JSON.stringify({
    //     proxyAddress,
    //     impleAddress,
    //     abi: auction.interface.format("json")
    // }));
    // console.log("部署信息已保存-------",storePath);
    // // 4.保存到hardhat-deploy的部署记录中
    // await save("AuctionProxy", {
    //     address: proxyAddress,
    //     abi: auction.interface.format("json")
    // });
};
module.exports.tags = ["deployAuction"];