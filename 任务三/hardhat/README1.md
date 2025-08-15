# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
1.安装node.js和npm设置   
管理员模式：Set-ExecutionPolicy RemoteSigned   npm init -y
2.npm install --save-dev hardhat
3.npx hardhat init
4.npx hardhat node
5.npx hardhat ignition deploy ./ignition/modules/Lock.js --network localhost  //部署到本地
npx hardhat ignition deploy ./ignition\modules\Lock.js --network sepolia   //部署到sepolia测试环境
6.npm install dotenv
重复部署问题：reset
7.npx hardhat ignition deploy ./ignition/modules/Lock.js --network sepolia  --reset

// 部署合约
npx hardhat deploy --tags deployNftAuction

// 拍卖流程
1.拍卖创建
2.竞拍开始
3.竞拍进行
4.竞拍结束
5.支付结算
6.交付拍品