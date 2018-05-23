pragma solidity ^0.4.20;

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract CrowdFunding{
    mapping(address => uint256) balances;
    using SafeMath for uint256;
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
    }
   
    function withdraw() public {
        uint amountToWithdraw = balances[msg.sender];
        require(amountToWithdraw > 0);
        if (msg.sender.call.value(amountToWithdraw)() == false) {
            revert();
        }
        balances[msg.sender] = 0;
    }
}