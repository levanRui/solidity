// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
创建一个名为 BeggingContract 的合约。
合约应包含以下功能：
一个 mapping 来记录每个捐赠者的捐赠金额。
一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
一个 withdraw 函数，允许合约所有者提取所有资金。
一个 getDonation 函数，允许查询某个地址的捐赠金额。
使用 payable 修饰符和 address.transfer 实现支付和提款。

*/
contract BeggingContract{
    // 记录每个捐赠者的捐赠金额
    mapping(address => uint256) public donateMap;
    // 当前合约所有者地址
    address public owner;
    // 构造函数：设置部署者为合约所有者
    constructor(){
        owner = msg.sender;
    }
    // // 修饰符：限制只有所有者可调用
    modifier onlyOwner(){
        require(msg.sender ==owner, "only owner can use");
        _;

    }
    //允许用户向合约发送以太币，并记录捐赠信息。
    function donate() external payable{
        // 校验捐赠金额
        require(msg.value>0,"donate money must greater 0");
        // 记录捐赠金额
        donateMap[msg.sender] += msg.value;
    }

}