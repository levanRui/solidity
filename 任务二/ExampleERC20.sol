// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// 导入 OpenZeppelin 的 Ownable
//import "@openzeppelin/contracts/access/Ownable.sol";
/**
一、任务要求：
任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包


二、任务流程
直接转账流程：
A 持有代币 → A 调用 transfer → B 收到代币

授权转账流程：
1. A 持有代币 → A 调用 approve 授权 B
2. B 作为 spender → B 调用 transferFrom → C 收到代币

直接转账：若无需第三方操作，直接使用 transfer。
授权转账：若需要第三方（如合约）代为操作，按以下步骤：
    代币持有者调用 approve(spender, amount) 设置授权。
    被授权的 spender 调用 transferFrom(owner, to, amount) 执行转账。
    若需更新授权额度，建议先 approve(spender, 0) 再设置新值。
*/
contract ExampleERC20 { 
    // 代币名称
    string private name;
    // 代币符号
     string private symbol;
     // 
     uint8 private decimals;
    // 代币总量
    uint256 private totalSupply;
    // 账户余额映射
    mapping(address => uint256) private balanceOfMap;
    // 授权额度映射
    mapping(address => mapping(address=> uint256)) private allowanceMap;
    // 合约所有者
    address private owner;

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 amount);
    // 授权事件
    event Approve(address indexed owner, address indexed spender, uint256 amount);
    // 定义 onlyOwner修饰器

    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner can call this function");
        _;// 继续执行函数体
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply){
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply *10 ** uint256(_decimals);
        //将所有代币发行给合约者
        balanceOfMap[msg.sender] = totalSupply;
        owner = msg.sender;

        emit Transfer(address(0), msg.sender, totalSupply);
        
    }
    //转账-转移代币:  _toAddress：代币接收者，仅被动接收代币，无需任何权限。
    function transfer(address _toAddress, uint256 _amount) public returns (bool){
        // 转账地址校验
        require(_toAddress != address(0),"ExampleERC20:  not transfer to zero address");
        // 余额校验
        require(balanceOfMap[owner] >= _amount,"ERC20: balance is not enough");
        // 转移代币
        balanceOfMap[owner]-=_amount;
        balanceOfMap[_toAddress] += _amount;
        // 触发转账事件
        emit Transfer(owner, _toAddress, _amount);
        return true;

    }
    //授权  _spender 是 “被授权的操作者”，拥有从他人账户中转出代币的权限（需通过 approve 授权）
    function approve(address _spender, uint256 _amount) public returns(bool){
        //授权地址校验
        require(_spender != address(0), "ExampleERC20: not transfer to zero address");
        // 让代币持有者（msg.sender）赋予另一个地址（_spender）动用自己代币的权限，并且可以指定允许动用的代币数量（_value）
        allowanceMap[owner][_spender] = _amount;
        // 触发授权事件
        emit Approve(owner, _spender, _amount);
        return true;
    }
    //代扣转账 _from就是_spender
    function transferFrom(address _from, address _to, uint256 _amount) public returns(bool){
        //1. _transfer(from, to, amount)：转移代币，确保 from 有足够余额。
        //2. _spendAllowance(from, _msgSender(), amount)：扣减授权额度（或验证无限授权）。
        require(balanceOfMap[_from] >=_amount,"transferFrom: not enough balance");
        require(allowanceMap[_from][owner] >= _amount,"allowance : Allowance is not enough");

        // 先转账
        balanceOfMap[_from]-=_amount; // 1。减少转出账户余额
        balanceOfMap[_to] += _amount; // 2.增加转入账户余额
        // 后扣减额度
        allowanceMap[_from][owner] -= _amount; // 3.减少_from对msg.sender(调用者)的授权额度
        // 触发转账事件
        emit Transfer(_from, _to, _amount);
        return true;
    }

    // 余额查询
    function balanceOf(address _address) public view returns (uint256){
        return _address.balance;
    }

    // 增发代币
    function mint(address _toAddress, uint256 _value) public onlyOwner {
        require(_toAddress != address(0),"mint not to zero address");
        uint256 amount = _value * 10 **uint256(decimals);
        totalSupply+=amount;
        balanceOfMap[_toAddress] +=amount;
        //代币从 零地址（address (0)） 转移到目标地址 _toAddress，实际上意味着这些代币是新创建的（增发）
        emit Transfer(address(0), _toAddress, amount);
    }
}
contract ExampleERC20Test{
    ExampleERC20 exampleERC20;
    // 初始化ExampleERC20
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply){
        exampleERC20 = new ExampleERC20(_name,_symbol,_decimals,_initialSupply);
    }
    // 测试直接转移代币
    function testTransferFrom(address _from, address _to, uint256 _amount) public returns(bool){
        exampleERC20.transfer(_from, _to, _amount);
    }
}
