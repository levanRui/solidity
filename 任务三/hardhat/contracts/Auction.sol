// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./FeedPrice.sol";
// 引入OpenZeppelin的重入保护
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
using SafeERC20 for IERC20;

import "hardhat/console.sol";

contract Auction is Initializable, ReentrancyGuard{
    FeedPrice public feedPrice;
    address public factoryAddress; // 工厂地址
    // 定义拍卖状态
    enum AuctionStatus{
        Active, // 活动中
        Ended,  // 已结束   
        Cancelled // 已取消
    }
    // 定义拍卖信息结构体
    struct AuctionInfo{
        address seller;// 卖家地址
        address nftContract;//NFT合约地址
        uint256 tokenId;//NFT id
        uint256 startPrice;//起始价格
        uint256 highestBid;//最高出价
        address highestBidder;//最高出价者
        uint256 endTime;//拍卖结束时间
        AuctionStatus status;//拍卖状态
        address paymentToken;//NFT合约地址
  
    }
    // 初始化 
    function initialize(
        address nftAddress,
        uint256 tokenId,
        address seller, // 卖家地址
        address paymentToken, // 支付代币地址
        uint256 startTime, // 开始时间
        uint256 endTime, // 结束时间   
        uint256 startPrice,
        uint256 duration,
        address feedPrice, // 价格预言机地址
        address factoryAddress // 工厂地址
    ) public initializer {
        require(nftAddress != address(0), "Invalid NFT address");
        require(duration > 0, "Duration must be greater than 0");
    }
    // 拍卖ID到拍卖信息的映射
    mapping(uint256 => AuctionInfo) public auctionMap; 
    // 记录竞标者的出价
    mapping(address => uint256) public bidMap;

    //1.创建拍卖：允许用户将 NFT 上架拍卖。
    function createAuction(
        address nftAddress,
        uint256 tokenId,
        address seller, // 卖家地址
        uint256 startPrice,
        uint256 paymentToken, // 支付代币地址
        uint256 startTime, // 开始时间
        uint256 endTime, // 结束时间   
        uint256 duration,
        address feedPrice, // 价格预言机地址
        address factoryAddress // 工厂地址
    ) public {
        require(nftAddress != address(0), "Invalid NFT address");
        require(duration> 0, "Duration must be greater than 0");
        // 创建拍卖信息
        AuctionInfo memory auction = AuctionInfo({
            seller: msg.sender,
            nftContract: nftAddress,
            tokenId: tokenId,
            startPrice: startPrice,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + duration,
            status: AuctionStatus.Active,
            paymentToken: address(0) // 默认为ETH支付
        });
        // 检查NFT是否存在，设置拍卖信息等
        // 这里可以添加逻辑来创建拍卖
    }
    //2.出价：允许用户以 ERC20 或以太坊出价。
    function placeBid(uint256 auctionID) external payable{
        uint256 bidAmount; 
        AuctionInfo storage auctionInfo = auctionMap[auctionID] ;
        if(auctionInfo.paymentToken== address(0)){
            //1.支付方式为ETH
            require(msg.value > auctionInfo.highestBid, "Bid must be higher than 0");
            bidAmount = msg.value;
        }else{
            // 2.支付方式为ERC20
            require(msg.value == 0, "Bid must be in ERC20 token");

            // 计算收到的代币数量
            uint256 beforeBalance = IERC20(auctionInfo.paymentToken).balanceOf(address(this));
            uint256 allowance = IERC20(auctionInfo.paymentToken).allowance(msg.sender, address(this));
            IERC20(auctionInfo.paymentToken).safeTransferFrom(msg.sender, address(this), allowance);
            uint256 afterBalance = IERC20(auctionInfo.paymentToken).balanceOf(address(this));
            bidAmount = afterBalance - beforeBalance;
            require(bidAmount > 0, "Bid amount must be greater than 0");
        }
        //检查出价是否高于当前最高出价
        require(bidAmount > auctionInfo.highestBid, "Bid must be higher than current highest bid");
    }
  
    //3.结束拍卖：拍卖结束后，NFT 转移给出价最高者，资金转移给卖家
    function endAuction(uint256 auctionID) external {
        AuctionInfo storage auctionInfo = auctionMap[auctionID];
        require(auctionInfo.status == AuctionStatus.Active, "Auction is not active");
        require(block.timestamp >= auctionInfo.endTime, "Auction has not ended yet");
        
        // 先保存必要信息到本地变量，避免外部调用前的状态变化
        address nftContract = auctionInfo.nftContract;
        uint256 tokenId = auctionInfo.tokenId;
        address seller = auctionInfo.seller;
        address highestBidder = auctionInfo.highestBidder;
        uint256 highestBid = auctionInfo.highestBid;
        address paymentToken = auctionInfo.paymentToken;

        // 检查-效果-交互模式，先更新状态
        auctionInfo.status = AuctionStatus.Ended;

        // 如果有最高出价者，转移NFT和资金
        if (highestBidder != address(0)) {
            // 先转移NFT给最高出价者
            IERC721(nftContract).safeTransferFrom(address(this), highestBidder, tokenId);
            // 再转移资金给卖家
            if (paymentToken == address(0)) {
                (bool sent, ) = payable(seller).call{value: highestBid}("");
                require(sent, "Failed to send Ether to seller");
            } else {
                IERC20(paymentToken).safeTransfer(seller, highestBid);
            }
        } else {
            // 如果没有出价者，NFT返回给卖家
            IERC721(nftContract).safeTransferFrom(address(this), seller, tokenId);
        }
    }

}