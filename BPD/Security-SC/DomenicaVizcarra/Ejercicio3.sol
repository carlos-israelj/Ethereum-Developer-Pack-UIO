// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleWithdrawals {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        require(msg.value > 0, "Solo depositos mayores que cero");
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) public {
        // C - Checks
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // E - Effects (actualizar estado antes de interactuar)
        balances[msg.sender] -= amount;
        
        // I - Interactions (último paso)
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transferencia fallida");
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
