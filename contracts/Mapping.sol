// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Mapping {
    mapping(address => uint) public balance;
    mapping(address => mapping(address=>bool)) public isFriend;

    function example() external {
        balance[msg.sender] = 123;
        uint bal = balance[msg.sender];
        uint bal2 =balance[address(1)];
        balance[msg.sender] += 456;
        isFriend[msg.sender][address(this)] = true;
    }

    function get(address _addr) public view returns (uint) {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.
        return balance[_addr];
    }

    function set(address _addr, uint _i) public {
        // Update the value at this address
        balance[_addr] = _i;
    }

    function remove(address _addr) public {
        // Reset the value to the default value.
        delete balance[_addr];
    }
}

contract IterableMapping {
    mapping(address => uint) public balance;
    mapping(address => bool) public inserted;
    address[] public keys;

    function set(address _key,uint _val) external {
        balance[_key] = _val;
        if ( !inserted[_key]) {
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function getSize() external view returns (uint) {
        return keys.length;
    }

    function first() external view returns (uint) {
        return balance[keys[0]];
    }

    function last() external view returns (uint) {
        return balance[keys[keys.length-1]];
    }

        function get(uint _i) external view returns (uint) {
        return balance[keys[_i]];
    }
}