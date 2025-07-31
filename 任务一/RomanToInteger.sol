// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//给定一个罗马数字，将其转换成整数。
 contract RomanToInteger{
    mapping(bytes1 => uint256) private romanMap;
    //I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。   IV:4 IX:9
    //X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 XL:40  XC:90
    //C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。 CD:500  CM:1000
    constructor(){
        romanMap['I'] = 1;
        romanMap['V'] = 5;
        romanMap['X'] = 10;
        romanMap['L'] = 50;
        romanMap['C'] = 100;
        romanMap['D'] = 500;
        romanMap['M'] = 1000;

        romanMap['a'] = 4;//IV
        romanMap['b'] = 9;//IX
        romanMap['c'] = 40;//XL
        romanMap['d'] = 90;//XC
        romanMap['e'] = 500;//CD
        romanMap['f'] = 1000;//CM
    }
    // 将罗马数字转换为整数
    function romanToInt(string memory romanStr) public view returns(uint256){   
        //MCMXCIV
        bytes memory romanBytes = bytes(romanStr);
        uint256 result = 0;
        for(uint i=0;i<romanBytes.length;i++){
            result += romanMap[romanBytes[i]];
        }
        return result;
    }
    // function replaceRomanStr(string memory romanStr) public view returns(string){
    //     return "";
    // }
   
 }
