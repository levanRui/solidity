// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 二分查找
contract HalfQuery{
    function findTarget(uint256[] memory numSortedArray, uint256 target) public pure returns(int){
        int left =0;
        int right = int(numSortedArray.length)-1;
        while(left<=right){
            int middle = left +(right-left) /2;
            uint256 middleValue = numSortedArray[uint256(middle)];
            if(middleValue == target){
                return middle;// 返回目标索引
            }else if(middleValue > target){
                right = middle -1; // 目标值在左半部分区域
            }else{
                left = middle+1; // 目标值在右半侧区域
            }
        }
        return -1; // 未找到目标索引
    }
}
