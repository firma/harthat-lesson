// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Receiver {
    event Log(bytes data);
    function transfer(address _to, uint amout) external{
        emit Log(msg.data);
    }
}

contract FunctionSelector {
    
    funciton getSelector(string calldata _func) external returns (bytes4){
        return bytes4(keccak256(bytes(_func)));
    }
}