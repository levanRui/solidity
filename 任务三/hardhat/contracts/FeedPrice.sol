// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract FeedPrice is Ownable {
    // Custom errors
    error PriceFeedNotSet();
    error InvalidPrice();
    error PriceFeedNotSetForToken();

    // 存储价格喂价合约地址
    mapping(address => address) public priceFeedMap;
    // ETH/USD喂价地址
    address public ETH_USD_PRICE_FEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    // 构造函数，显式传递初始owner
    constructor(address initialOwner) Ownable(initialOwner) {}

    // 1.设置ERC20代币的喂价
    function setPriceFeed(address token, address feedAddress) public {
        priceFeedMap[token] = feedAddress;
    }
    // 2.设置ETH/USD喂价地址
    function setEthUsdPriceFeed(address feedAddress) external onlyOwner {
        ETH_USD_PRICE_FEED = feedAddress;
    }
    // 获取ETH/USD价格
    function getEthUsdPrice() public view returns (uint256) {
        if (priceFeedMap[ETH_USD_PRICE_FEED] == address(0)) revert PriceFeedNotSet();

        //  Chainlink 价格馈送（Price Feed）获取最新的价格数据
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeedMap[ETH_USD_PRICE_FEED]);

        (, int256 price, , , ) = priceFeed.latestRoundData();
        if (price <= 0) revert InvalidPrice();
        // Chainlink价格通常有8位小数，转换为18位小数
        return uint256(price) * 10**10; // 返回18位小数的价格
    }
    // 获取ERC20代币的USD价格
    function getTokenUsdPrice(address token) public view returns(uint256){
        address feedAddress = priceFeedMap[token];
        if (feedAddress == address(0)) revert PriceFeedNotSetForToken();
        AggregatorV3Interface priceFeed = AggregatorV3Interface(feedAddress);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        if (price <= 0) revert InvalidPrice();
        // 假设价格喂价有8位小数，转换为18位小数
        return uint256(price) * 10**10;
    }
}