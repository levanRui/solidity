const{deployments,upgrades,ethers}=require("hardhat");
const fs=require("fs");
const path=require("path");
module.exports = async ({getNamedAccounts, deployments})=>{
    const {save} = deployments;
    const {deployer} = await getNamedAccounts();
    console.log("部署用户地址-------",deployer);
    // 1.部署用户地址
    const auction = await ethers.getContractFactory("Auction");
    console.log("auction合约工厂-------",auction);

    // 2.通过代理合约部署
    const auctionProxy = await upgrades.deployProxy(auction,[],{initializer:"initialize"});
    await auctionProxy.waitForDeployment();
    console.log("auction合约代理地址-------",auctionProxy.target);
     // 获取代理合约地址
     const proxyAddress = auctionProxy.getAddress();
     console.log("auction合约代理地址-------",proxyAddress);
     // 获取实现合约地址
     const impleAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
     console.log("auction合约实现地址-------",impleAddress);
    // 3.保存部署信息
    const storePath = path.join(__dirname,"./.cache/proxyAuction.json");
    fs.writeFileSync(storePath,JSON.stringify({
        proxyAddress,
        impleAddress,
        abi: auction.interface.format("json")
    }));
    console.log("部署信息已保存-------",storePath);
    // 4.保存到hardhat-deploy的部署记录中
    await save("AuctionProxy", {
        address: proxyAddress,
        abi: auction.interface.format("json")
    });
};
module.exports.tags = ["deployAuction"];