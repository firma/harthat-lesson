// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract HashFunc {
    function hash(string memory text, uint num, address addr ) external pure returns (bytes32){
        return keccak256(abi.encodePacked(text,num,addr));
    }

    function encode(string memory text, address addr ) external pure returns (bytes32){
        return keccak256(abi.encode(text,addr));
    }

    function encodePacked(string memory text, address addr ) external pure returns (bytes32){
        return keccak256(abi.encode(text,addr));
    }

    function collision(string memory text, uint num, address addr ) external pure returns (bytes32){
        return  keccak256(abi.encode(text,num,addr));
    }

    function collisionOne(string memory text, uint num, address addr ) external pure returns (bytes32){
        return keccak256(abi.encode(text,num,addr));
    }
}