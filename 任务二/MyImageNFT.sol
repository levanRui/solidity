// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 导入 OpenZeppelin 的 ERC721 库
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



//合约地址：0x5D53DcB370ee5EB9699A06da98f74AcBefA92080
// 合约继承自ERC721、ERC721URIStorage和Ownable
contract MyImageNFT is ERC721,ERC721URIStorage,Ownable{
    // 用于定位可用的tokenId
    uint256 private nftTokenCounter;
    constructor() ERC721("My ImageNft", "IMAGE") Ownable(msg.sender){
        nftTokenCounter = 1; // 从1开始计数
    }
      // 定义 onlyOwner修饰器

    // modifier onlyOwner(){
    //     require(msg.sender == nftAdress,"Only owner can call this function");
    //     _;// 继续执行函数体
    // }
    // 铸造NFT
    function mintNFT(address toAddress, string memory tokenURI) public onlyOwner{
        uint256 tokenId = nftTokenCounter;
        nftTokenCounter++;
        // 安全铸造nft到_toAddress
        _safeMint(toAddress, tokenId);
        // 设置NFT的元数据连接
        _setTokenURI(tokenId, tokenURI);

    }
    // 重写tokenURI
    function tokenURI(uint256 tokenId) public view override (ERC721,ERC721URIStorage) returns(string memory){
        return super.tokenURI(tokenId);
    }
    // 重写supportsInterface
    function supportsInterface(bytes4 interfaceId) public view  override(ERC721, ERC721URIStorage)returns (bool){
        return super.supportsInterface(interfaceId);
    }

}