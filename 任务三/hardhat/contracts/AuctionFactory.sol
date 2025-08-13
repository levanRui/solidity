// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./Auction.sol";
import "./UpgradeBaseAuction.sol";
contract AuctionFactory is UpgradeBaseAuction {
    using Clones for address;// 方便使用克隆方法
    // 定义拍卖合约实现地址
    address public auctionImplAddress;
    // 价格预言机地址
    address public priceFeedAddress;

    //记录NFT的当前拍卖
    mapping(address => mapping(uint256 => address)) public nftCurrentAuction;

    // 记录所有拍卖合约地址
    address[] public allAuctions;
    // 记录用户创建的拍卖
    mapping(address => address[]) public userAuctions;
    // 事件：拍卖创建
    event AuctionCreated(
        address indexed auctionAddress,
        address indexed nftContract,
        uint256 tokenId,
        address indexed seller,
        uint256 startPrice,
        uint256 endTime
    );
    //事件：部署
    event AuctionDeployed(
        address indexed auctionAddress,
        address indexed nftAddress,
        uint256 tokenId,
        address indexed seller
    );
    // 初始化函数，设置拍卖合约实现地址和价格预言机地址
    function initialize(address _auctionImplAddress, address _priceFeedAddress) external initializer {
        require(auctionImplAddress == address(0), "Already initialized");
        auctionImplAddress = _auctionImplAddress;
        priceFeedAddress = _priceFeedAddress;
    }

    // 1.创建新拍卖
    function createAuction(
        address nftAddress,// NFT合约地址
        uint256 tokenId,
        address seller, // 卖家地址
        address paymentToken,// 支付代币地址
        uint256 startTime,
        uint256 endTime,
        uint256 startPrice,// 起始价格 美元18位小数
        address feedPrice, // 价格预言机地址
        uint256 duration,
        address factory
    ) public returns (address) {
        require(nftCurrentAuction[nftAddress][tokenId] != address(0), "Invalid NFT address");
        require(duration > 0, "Duration must be greater than 0");

       // 检查NFT所有权
       require(IERC721(nftAddress).ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");

        // 检查NFT授权
        require(IERC721(nftAddress).isApprovedForAll(msg.sender, address(this)) 
        || IERC721(nftAddress).getApproved(tokenId) == address(this), 
        "AuctionFactory is not approved to transfer this NFT");
        // 创建拍卖合约
        address newAuction = auctionImplAddress.clone();
        // 初始化拍卖合约
        Auction(newAuction).initialize(
            nftAddress,
            tokenId,
            seller,
            paymentToken,
            startTime,
            endTime,
            startPrice,
            feedPrice,
            duration,
            factory
        );
        // 记录拍卖
        nftCurrentAuction[nftAddress][tokenId] = newAuction;
        allAuctions.push(newAuction);
        userAuctions[seller].push(newAuction);
        // 触发事件
        emit AuctionDeployed(newAuction, nftAddress, tokenId, seller);

        return newAuction;
    }
    
}