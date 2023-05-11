// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bider, uint amount);
    event End(address indexed highestbidder, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address public immutable seller;
    uint32 public immutable endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);

        highestBid = _startingBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 60);
        ntf.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value > highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(!ended, "not ended");

        require(block.timestamp >= endAt, "not ended");

        ended = true;

        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transferFrom(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address public immutable seller;

    uint public immutable startingPrice;

    uint public immutable startAt;
    uint public immutable expiredsAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _nft,
        uint _nftId,
        uint _discountRate
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;

        startAt = block.timestamp;

        expiredsAt = startAt + DURATION;

        require(
            _startingPrice >= _discountRate * DURATION,
            "starting price < discount"
        );

        nft = IERC721(_nft);
        nftId = nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElaspsed = block.timestamp - startAt;
        uint discount = discountRate * timeElaspsed;

        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiredsAt, "auction expired");

        uint price = getPrice();

        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftId);

        uint refund = msg.value - price;

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        selfdestruct(payable(seller));
    }
}
