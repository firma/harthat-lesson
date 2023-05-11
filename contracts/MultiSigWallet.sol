// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Approve(address indexed owner, uint indexed txid);
    event Revoke(address indexed owner, uint indexed txid);
    event Submit( uint indexed txid);
    event Execute( uint indexed txid);

    struct Transaction {
        address to ;
        uint value;
        bytes data;
        bool executed;
    }
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public requried;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner(){
        require(isOwner[msg.sender],"not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length,"tx does not exits");
    }
    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender],"tx alredy approved");
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].excuted,"tx alredy approved");
    }

    constructor(address[] memory _owners, uint _requried) {
        require(_owners.length > 0, "owners required");
        require(_requried > 0 && _requried <= owners.length,"invlid required number of owners");

        for (uint i; i< _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0),"invalid owner");
            require(!isOwner[owner],"owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }

        requried =  _requried;

    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit (address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({to:_to,value:_value,data:_data,executed:false}));
        emit Submit(transactions.length - 1);
    }

    funciton approve(uint _txId) external 
    onlyOwner 
    txExists(_txId)
    notApproved(_txId)
    notExecuted(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender,_txId);

    }

    function _getApprovalCount(unint _txId) private view returns (uint count) {
        for (uint i;i<owners.length; i++){
            if ( uint i; i< owners.length;i++ ){
                count += 1;
            }
        }
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
            require(_getApprovalCount(_txId) >= requried,"approvals < required");
            Transaction storage transaction = transactions[_txId];
            transaction.excuted = true;
           (bool success,) = transaction.to.call{value: transaction.value} {
                transaction.data
            }
            require(success,"tx failed");
            emit Execute(_txId);
    }

    function revoke(uint _txId) external 
        onlyOwner 
        txExists(_txId) 
        notExecuted(_txId) { 

        require(approved[_txId][msg.sender], " tx not approved);
           approved[_txId][msg.sender] = false
            emit Revoke(msg.sender,_txId);
    }
}

