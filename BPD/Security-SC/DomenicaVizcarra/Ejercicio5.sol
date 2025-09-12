// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleEmergency {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public pendingWithdrawals; // Nuevo mapping
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "Solo depositos mayores que cero");
        balances[msg.sender] += msg.value;
    }
    
    // En lugar de transferir directamente se marcan los fondos como pendientes de retiro
    function emergencyWithdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No hay fondos en el contrato");
        
        pendingWithdrawals[owner] += amount;
    }
    
    // Permite ver cuánto tiene pendiente el msg.sender
    function getPendingWithdrawal() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }
    
    // Cada usuario retira sus fondos cuando quiera
    function withdrawPending() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No hay retiros pendientes");
        
        // CEI: primero actualizamos estado, luego interacción
        pendingWithdrawals[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transferencia fallida");
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
