// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
<<<<<<< HEAD
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

using SafeERC20 for IERC20;

=======
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

>>>>>>> origin/main
import "hardhat/console.sol";

contract Auction{
    // 定义拍卖状态
    enum AuctionStatus{
        Active, // 活动中
        Ended,  // 已结束   
        Cancelled // 已取消
    }
    // 定义拍卖信息结构体
    struct AuctionInfo{
        address seller;// 卖家地址
<<<<<<< HEAD
        address nftContract;//NFT合约地址
=======
        address nftContractAddress;//NFT合约地址
>>>>>>> origin/main
        uint256 tokenId;//NFT id
        uint256 startPrice;//起始价格
        uint256 highestBid;//最高出价
        address highestBidder;//最高出价者
        uint256 endTime;//拍卖结束时间
        AuctionStatus status;//拍卖状态
        address paymentToken;//NFT合约地址
  
    }
    // 拍卖ID到拍卖信息的映射
    mapping(uint256 => AuctionInfo) public auctionMap; 
    // 记录竞标者的出价
    mapping(address => uint256) public bidMap;
    //1.创建拍卖：允许用户将 NFT 上架拍卖。
    function createAuction(
        address nftAddress,
        uint256 tokenId,
        uint256 startPrice,
        uint256 duration
    ) public {
        require(nftAddress != address(0), "Invalid NFT address");
        require(duration> 0, "Duration must be greater than 0");
        // 创建拍卖信息
        AuctionInfo memory auction = AuctionInfo({
            seller: msg.sender,
<<<<<<< HEAD
            nftContract: nftAddress,
=======
            nftContractAddress: nftAddress,
>>>>>>> origin/main
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
<<<<<<< HEAD
        if(auctionInfo.paymentToken== address(0)){
=======
        if(auctionInfo.nftContractAddress== address(0)){
>>>>>>> origin/main
            //1.支付方式为ETH
            require(msg.value > auctionInfo.highestBid, "Bid must be higher than 0");
            bidAmount = msg.value;
        }else{
            // 2.支付方式为ERC20
<<<<<<< HEAD
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
  
=======

            // 计算收到的代币数量
            uint256 tokenAmount = IERC20(auctionInfo.nftContractAddress).balanceOf(msg.sender);
        }


        // 检查拍卖是否存在，是否在活动中
        // 检查出价是否高于当前最高出价
        // 更新最高出价和最高出价者
        // 这里可以添加逻辑来处理出价
    }
>>>>>>> origin/main
    //3.结束拍卖：拍卖结束后，NFT 转移给出价最高者，资金转移给卖家

}