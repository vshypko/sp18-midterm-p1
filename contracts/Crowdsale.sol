pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
    using SafeMath for uint256;

    uint256 tokensSold;
    uint256 startTime;
    uint256 endTime;
    address owner;
    uint256 initialAmount;
    uint256 weiWorth;

    Token token;
    Queue queue;

    event TokenPurchase(address indexed _address, uint256 _value);
    event TokenRefund(address indexed _address, uint256 _value);

    function Crowdsale () {
        owner = msg.sender;
        startTime = now;
        endTime = now.add(10 days); // ?
        initialAmount = 1000000;
        weiWorth = 1;
        token = new Token();
        queue = new Queue();
    }

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    modifier saleActive() {
        require(endTime > now);
        _;
    }

    modifier canBuy() {
        require(msg.sender == queue.getFirst());
        require(queue.qsize() > 1);
        _;
    }

    function mint(uint256 _value) ownerOnly {
        token.mintTokens(_value);
    }

    function burn(uint256 _value) ownerOnly {
        require(token.balanceOf(owner) >= _value);

        token.burnTokens(_value);
    }

    function buyTokens() payable saleActive canBuy {
        token.transfer(msg.sender, msg.value.mul(weiWorth));
        tokensSold.add(msg.value.mul(weiWorth));
        queue.dequeue();
        TokenPurchase(msg.sender, msg.value.mul(weiWorth));
    }

    function refundTokens() payable saleActive {
        uint256 toRefund = token.balanceOf(msg.sender).div(weiWorth);
        token.decreaseBalance(msg.sender, token.balanceOf(msg.sender));
        msg.sender.transfer(toRefund);
        tokensSold.sub(toRefund);
    }

    function forwardFunds() ownerOnly returns(bool) {
        require(now > endTime);

        return owner.send(this.balance);
    }

    function () payable {
        revert();
    }
}
