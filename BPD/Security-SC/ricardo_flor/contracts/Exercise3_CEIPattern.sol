// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleWithdrawals {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) public {
        //Checks
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        //Effects
        balances[msg.sender] -= amount;

        //Interactions
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}