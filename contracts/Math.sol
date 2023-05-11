// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

library Match {
    function max(uint x,uint y) internal pure returns (uint) {
        return x >= y ? x:y;
    }
}

library ArrayLib {
    function find(uint[] storage arr, uint x) internal view returns (uint) {
        for (uint i = 0;i< arr.length;i++) {
            if (arr[i]==x) {
                return i;
            } 
        }
        revert("not found");
    }

}