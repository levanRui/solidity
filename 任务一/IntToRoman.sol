// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//给定一个整数转为罗马数字
 contract IntToRoman{
    //mapping(bytes8 => uint256) private romanMap;
    uint256[]  intValues = new uint256[](13);
    string[]  romanValues = new string[](13);
    //I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。   IV:4 IX:9
    //X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 XL:40  XC:90
    //C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。 CD:500  CM:1000
    constructor(){
        intValues[0] = 1000;
        intValues[1] = 900;
        intValues[2] = 500;
        intValues[3] = 400;
        intValues[4] = 100;
        intValues[5] = 90;
        intValues[6] = 50;
        intValues[7] = 40;
        intValues[8] = 10;
        intValues[9] = 9;
        intValues[10] = 5;
        intValues[11] = 4;
        intValues[12] = 1;

        romanValues[0] = "M"; //1000
        romanValues[1] = "CM";//900
        romanValues[2] = "D";//500
        romanValues[3] = "CD";//400
        romanValues[4] = "C";//100
        romanValues[5] = "XC";//90
        romanValues[6] = "L";//50
        romanValues[7] = "XL";//40
        romanValues[8] = "X";//X
        romanValues[9] = "IX";//9
        romanValues[10] = "V";//5
        romanValues[11] = "IV";//4
        romanValues[12] = "I";//1
    }
    // 将整数转换为罗马数字
    function intToRoman(uint256 num) public view returns(string memory){   
        //  测试1994  返回MCMXCIV
        //  测试58 返回LVIII
        // 最大的罗马数字（3999）有15个字符
        bytes memory romanResult = new bytes(15);
        uint256 index= 0;// 满足num >= intValues[i]，index才会递增
        for(uint256 i=0;i<intValues.length;i++){
            while(num >= intValues[i]){
                bytes memory romanBytes = bytes(romanValues[i]);
                // romanValues[i]里面包含多个字符
                for(uint256 k=0;k<romanBytes.length;k++){
                    romanResult[index]=romanBytes[k];
                    index++;
                }
                num -= intValues[i];
            }
        }
        return string(romanResult);
    }
   
 }
