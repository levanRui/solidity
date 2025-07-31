// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract StringReverse{
    // 字符串反转操作
    function reverse(string memory dataStr) public pure returns (string memory){
        // 1.将字符串转换为bytes以访问单个字符
        bytes memory strBytes = bytes(dataStr);
        uint256 strLen = strBytes.length;
        // 2.校验字符串长度
        // 如果字符串为空或者只有一个字符直接返回
        if(strLen <=1){
            return dataStr;
        }
        // 3.循环将字符反转
        bytes memory reverseBytes = new bytes(strLen);
        for(uint256 i=0;i<strLen;i++){
            reverseBytes[i] = strBytes[strLen-i-1];
        }
        // 4.将bytes转换为string返回
        return string(reverseBytes);
    }
    function testReverse(string memory _dataStr) public view returns(string memory){
       return reverse(_dataStr);
    }
}
