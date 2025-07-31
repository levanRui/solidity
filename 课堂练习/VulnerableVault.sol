pragma solidity^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract VulnerableVault is ReentrancyGuard{
    mapping(address => uint) public balances;
    function desposit() external payable{
        balances[msg.sender] +=msg.value;
    }
    // 1.未修正的逻辑
    // function withdraw() external {
    //     require(balances[msg.sender] > 0, "No balance");
    //     // 发送ETH (外部调用，容易被攻击者重入)
    //     (bool success,) = msg.sender.call{value: balances[msg.sender]}("");
    //     require(success, "Transfer failed.");

    //     //更新余额 (放在调用后， 容易被攻击者重入)
    //     balances[msg.sender] = 0;
    // }
    //2.修正后的逻辑
    // function withdraw() external {
    //      //先更新状态再转账
    //     uint256 balance =balances[msg.sender];
    //     balances[msg.sender] = 0;
    //     require(balances[msg.sender] > 0, "No balance");
    //     // 发送ETH (外部调用，容易被攻击者重入)
    //     (bool success,) = msg.sender.call{value: balance}("");
    //     require(success, "Transfer failed.");
    // } 

    // 3.openzeppelin的ReentrancyGuard
      function withdraw() external nonReentrant{
        require(balances[msg.sender] > 0, "No balance");
        // 发送ETH (外部调用，容易被攻击者重入)
        (bool success,) = msg.sender.call{value: balances[msg.sender]}("");
        require(success, "Transfer failed.");
        //更新余额 (放在调用后， 容易被攻击者重入)
        balances[msg.sender] = 0;
    }
}
contract Attacher{
    VulnerableVault public target;
    constructor(address _target){
        target = VulnerableVault(_target);
    }

    //回调函数，趁机再次提取
    receive() external payable {
        if(address(target).balance > 1 ether){
            target.withdraw();
        }
    }
    function attack() external payable{
        require(msg.value >= 1 ether, "Need 1 ether");
        target.desposit{value: 1 ether}();
        target.withdraw();
    }
}
