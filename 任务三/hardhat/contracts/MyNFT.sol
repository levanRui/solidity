// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyNFT is ERC721, Ownable {
    uint256 public nftTokenCounter;
    // 构造函数：初始化NFT名称和符号，设置部署者为所有者
    constructor(
        string memory name, 
        string memory symbol,
        address initialOwner
    ) ERC721(name, symbol) Ownable(initialOwner) {
        nftTokenCounter = 1; 
    }
    // 初始化函数，供可升级合约使用
    // function initialize(
    //     string memory name, 
    //     string memory symbol
    // ) public {
    //     require(nftTokenCounter == 0, "Already initialized");
    //     //_transferOwnership(initialOwner);
    //     nftTokenCounter = 1; 
    // }
    // 铸造NFT
    function mintNFT(address toAddress) public onlyOwner returns (uint256) {
        uint256 newTokenId = nftTokenCounter;
        _safeMint(toAddress, newTokenId);
        nftTokenCounter++;
        return newTokenId;
    }

        /**
     * 转移NFT
     * 任何NFT持有者都可以调用此函数转移自己拥有的NFT
     * @param from 发送者地址
     * @param to 接收者地址
     * @param tokenId 要转移的NFT ID
     */
    function transferNFT(address from, address to, uint256 tokenId) public {
        // 检查调用者是否为所有者或被授权者
        require(isApprovedForAll(_msgSender(),ownerOf(tokenId)), "caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }
    
    /**
     * @dev 获取下一个将要铸造的NFT ID
     */
    function getNextTokenId() public view returns (uint256) {
        return nftTokenCounter;
    }

}