// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Payable {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() external payable {

    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}

contract Fallback {
    event Log(string func, address sender, uint value, bytes data);


    fallback() external payable{
        //TODO 
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        //TODO 
        emit Log("receive", msg.sender, msg.value, "");
    }

}

contract SendEther {
    constructor() payable {

    }

    receive() external payable{

    }

    function SendViaTransfer(address payable _to) external payable{
        _to.transfer(123);
    }

    function sendViaSend(address payable _to) external payable{
bool status =  _to.send(123);
        require(status,"send failed");
    }
    function SendViaCall(address payable _to) external payable{
    (bool success, )  =  _to.call{value:123}("");
    require(success,"call failed");
    }
}

contract EthReceve{
    event Log (uint amount, uint gas);

    receive() external payable {
        emit Log(msg.value,gasleft());
    }

}


contract EtherWallet {
    address payable public immutable owner;
    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable {    }

    function withdra(uint _amount) external {
        require(msg.sender == owner,"call is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}


interface ICounter{
    function count() external view returns (uint);
    function inc() external;
}


contract CallInterface {
    uint public count ;
    function example(address _counter) external {
        ICounter(_counter).inc();
        count = ICounter(_counter).count();
    }
}

contract testCall {
    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable {
        emit Log("fallback was called");
    }

    function foo(string memory _message,uint _x) external payable returns(bool,uint){
        message = _message;
        x = _x;
        return(true,999);
    }

}

contract Call {
    bytes public data;
    function callFoo(address _test) external  payable{
        (bool success,bytes memory _data) = _test.call{value:111}(
            abi.encodeWithSignature(
            "foo(string uint254)", "call fooo",123
            )
         );
        require(success,"call failed");
        data = _data;
    }

    function callDoesNotExit (address _test) external {
         (bool success, ) =  _test.call(abi.encodeWithSignature(
            "doesNotExist()"
            ));
        require(success,"call failed");
    }
}

//委托调用

contract TestDelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars (uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;
    
    function setVars(address _test,uint _num) external payable {
         (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
         );
         require(success,"delegatecall failed");
    }

}



contract Account {

    address public owner;
    address public bank;
    constructor(address _owner) payable{
        owner = _owner;
        bank = msg.sender;
    }
}

contract AccountFactory {

    Account[] public accounts;
    
    function createAccount(address _owner) external{
        // {value:111} 主币
        Account account = new Account{value:111}(_owner);
        accounts.push(account);
    }

}