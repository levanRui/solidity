// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@chainlink/contracts/node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Auction.sol";
pragma solidity ^0.8.17;
contract UpgradeAuction is Initializable, OwnableUpgradeable{
    using SafeERC20 for IERC20;
    // 升级拍卖合约逻辑
    address public auctionLogicAddress;

    // 初始化函数，设置拍卖合约逻辑地址
    function initialize(address _auctionLogicAddress) external initializer {
        require(auctionLogicAddress == address(0), "Already initialized");
        auctionLogicAddress = _auctionLogicAddress;
    }
    // /**
    //  * 提取竞拍押金
    //  * @param bidder 竞标者地址
    //  * @dev 允许竞标者提取他们的押金
    //  * 注意：此函数需要与ReentrancyGuard一起使用，以防止重入攻击
    //  * 竞标者可以在拍卖结束后提取押金，或者在拍卖取消时提取押金
    //  * 如果竞标者在拍卖结束时是最高出价者，则押金将被转化为拍卖的最终成交价
    //  * 如果竞标者不是最高出价者，则押金将被退还给他们
    //  * 注意：此函数不允许在拍卖进行中调用，必须在拍卖结束或取消后调用
    //  */
    // function withdrawDeposit(address bidder) external {
    //     require(bidder != address(0), "Invalid bidder address");
    //     uint256 amount = bidMap[bidder];
    //     require(amount > 0, "No deposit to withdraw");
    //     bidMap[bidder] = 0; // 清除押金
    //     IERC20(auctionLogicAddress).safeTransfer(bidder, amount); // 转回押金
    // }
    function _authorizeUpgrade(address newImplementation) internal onlyOwner {
        // 仅允许合约所有者升级
        require(newImplementation != address(0), "Invalid implementation address");
        auctionLogicAddress = newImplementation;
    }
   
}