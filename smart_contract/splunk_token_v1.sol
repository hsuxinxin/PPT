pragma solidity ^0.4.20;

contract SplunkToken{
    string public name = "SplunkChain";
    string public symbol = "SPL";
    string public version = '1.0.0';
    uint8 public decimals = 2;
    uint256 public totalSupply;
    mapping(address => uint256) balances;

    function SplunkToken() {
        totalSupply = 100 * (10**(uint256(decimals)));
        balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
    }
    
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value > 0 && _value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        return true;
    }
    
    function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
        uint cnt = _receivers.length;
        uint256 amount = uint256(cnt) * _value;
        require(cnt > 0 && cnt <= 20);
        require(_value > 0 && balances[msg.sender] >= amount);

        balances[msg.sender] = balances[msg.sender] - amount;
        for (uint i = 0; i < cnt; i++) {
            balances[_receivers[i]] = balances[_receivers[i]] + _value;
        }
        return true;
   }
}

