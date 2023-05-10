// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Structs {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;

    mapping(address => Car[]) public cardsByOwner;

    function examples() external{
        Car memory toyota = Car("Toyota",19991,msg.sender);
        Car memory lambo = Car({model:"lamborghini",year:1911,owner:msg.sender});
        Car memory tesla;
        tesla.model = "tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;
        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        cars.push( Car("Toyota",19991,msg.sender));
        // Car memory _car = cars[0];
        // _car.model;

        Car storage _car = cars[0];
        _car.year = 1101;
        delete _car.year;
    }
}