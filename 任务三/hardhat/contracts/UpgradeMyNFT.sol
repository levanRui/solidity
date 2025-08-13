// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./MyNFT.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
/**
 * @title MyNFTv2
 * @dev 升级后的合约，将原有NFT合约升级为ERC20标准代币
 * 使用透明代理模式实现可升级性
 */
contract UpgradeMyNFT is MyNFT, Initializable {
    // 新增的状态变量 - 必须放在所有原有状态变量之后
    uint256 private maxTotalSupply;
    // 新增状态变量：NFT基础URI
    string public baseURI;
    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) MyNFT(name, symbol, initialOwner) {}
    // 1.初始化函数，供可升级合约使用
    // 注意：此函数只能被调用一次，且必须在合约部署后立即调用
    // 这里使用了initializer修饰符，确保该函数只能被调用一次
    function initializeV2(
        string memory name,
        string memory symbol,
        address initialOwner,
        uint256 _maxTotalSupply,
        string calldata _baseURI
    ) public initializer {
        MyNFT.initialize(name, symbol, initialOwner);
        maxTotalSupply = _maxTotalSupply;
        baseURI = _baseURI;
    }

    // 2.新增mint函数，添加最大供应量限制
    function safeMint(address toAddress) public onlyOwner {
        require(nftTokenCounter < maxTotalSupply, "Max total supply reached");
        super.mintNFT(toAddress);
    }

    // 3.新增批量铸造功能
    function batchMint(address toAddress, uint256 numberOfTokens) public onlyOwner {
        require(nftTokenCounter + numberOfTokens <= maxTotalSupply, "Exceeds max total supply");
        for (uint256 i = 0; i < numberOfTokens; i++) {
            super.mintNFT(toAddress);
        }
    }
    // 4.新增设置基础URI功能
    function setBaseURI(string calldata _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }
    function newFunction() public pure returns (string memory) {
        return "This is a new function in MyNFTV2";
    }
}
