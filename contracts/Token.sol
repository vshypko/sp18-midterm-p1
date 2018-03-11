pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
    using SafeMath for uint256;

    string public constant name = "Midterm Token";
    string public constant symbol = "MIDT";

    uint256 public totalSupply;
    uint256 public tokenCap; // ?
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function Token () public {
        totalSupply = 1000000;
        balances[msg.sender] = 1000000;
    }

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256) {
        return balances[_owner];
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool) {
        require(_value > 0);

        if (balances[msg.sender] >= _value) {
            balances[msg.sender].sub(_value);
            balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
        require(_value > 0);

        if ((balances[_from] >= _value)
            && (allowed[_from][msg.sender] >= _value)) {
            balances[_from].sub(_value);
            balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        if (allowed[msg.sender][_spender] == _value) {
            return true;
        } else {
            return false;
        }
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256) {
        return allowed[_owner][_spender];
    }

    function burnTokens (uint256 _value) public returns (bool) {
        require(balances[msg.sender] >= _value);

        if (transfer(address(0), _value)) {
            totalSupply.sub(_value);
            return true;
        } else {
            return false;
        }
    }

    function mintTokens (uint256 _value) {
        totalSupply.add(_value);
    }

    function decreaseBalance(address _address, uint256 _value) {
        balances[_address].sub(_value);
    }
}
