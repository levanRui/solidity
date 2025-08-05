// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
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
        address nftAddressl;//NFT合约地址
        uint256 tokenId;//NFT id
        uint256 startPrice;//起始价格
        uint256 highestBid;//最高出价
        address highestBidder;//最高出价者
        uint256 endTime;//拍卖结束时间
        AuctionStatus status;//拍卖状态
  
    }
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
            nftAddressl: nftAddress,
            tokenId: tokenId,
            startPrice: startPrice,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + duration,
            status: AuctionStatus.Active
        });
        // 检查NFT是否存在，设置拍卖信息等
        // 这里可以添加逻辑来创建拍卖
    }
    //2.出价：允许用户以 ERC20 或以太坊出价。
    //3.结束拍卖：拍卖结束后，NFT 转移给出价最高者，资金转移给卖家
}