const{deployments,upgrades,ethers}=require("hardhat");
const fs=require("fs");
const path=require("path");
module.exports = async ({getNamedAccounts, deployments})=>{
    const { deployer } = await getNamedAccounts();

    console.log("Deploying auction system with the account:", deployer);

    // 1.部署NFT合约
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const myNFT = await MyNFT.deploy("MyAuctionMarketNFT", "AMNFT",deployer);
    myNFT.waitForDeployment();
    // 获取NFT合约地址
    const myNFTAddress = await myNFT.getAddress();
    console.log("MyNFT deployed to:", myNFTAddress);

    // 2.部署NFT升级合约
    const UpgradeMyNFT = await ethers.getContractFactory("UpgradeMyNFT");
    const upgradeMyNFT = await upgrades.deployProxy(
        UpgradeMyNFT, 
        ["MyAuctionMarketNFT", "AMNFT",deployer], {
        initializer: "initializeV2",
        kind: "transparent" //代理类型，可选 'transparent' 或 'uups'
    });
    upgradeMyNFT.waitForDeployment();
    // 获取NFT升级合约地址
    const upgradeMyNFTAddress = await upgradeMyNFT.getAddress();
    console.log("UpgradeMyNFT deployed to:", upgradeMyNFTAddress);

};
module.exports.tags = ["deployMyNFT"];