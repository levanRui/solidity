// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    //一个mapping来存储候选人的得票数
    mapping(string => uint256) private candiateNumMap;
    // 记录投票人，防止重复投票   address:存储投票人地址   bool:记录投票人是否投票
    mapping(address => bool) private voterFlagMap;
    //一个vote函数，允许用户投票给某个候选人
    function vote(string calldata candidater) external {
        // 1.检查是否已经投过票
        require(!voterFlagMap[msg.sender], "current voter already has voted");
        // 2.增加候选人的得票数
        candiateNumMap[candidater]++;
        // 3.将当前投票人标记为已投票
        voterFlagMap[msg.sender] = true;
    }
    //一个getVotes函数，返回某个候选人的得票数
    function getVotes(string calldata candidater) external view returns (uint256){
        return candiateNumMap[candidater];
    }
    //一个resetVotes函数，重置所有候选人的得票数
    function resetVotes() external {
        //sstore是 EVM 的存储写入操作码，用于将值存储到合约存储中
        //candiateNumMap.slot表示获取candidateVotes变量在存储中的位置（存储槽号）
        //第二个参数0是要存储的值

        //Solidity Assembly 代码用于将candidateVotes变量的存储值重置为 0
        assembly{
            sstore(candiateNumMap.slot,0)
        }
        // 重置所有投票记录
        assembly{
            sstore(voterFlagMap.slot, false)
        }
    }
}
