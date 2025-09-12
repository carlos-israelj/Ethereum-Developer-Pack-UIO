// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleDeposits {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        // Validación: no permitir depósitos de 0
        require(msg.value > 0, "Solo depositos mayores que cero");
        
        balances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
