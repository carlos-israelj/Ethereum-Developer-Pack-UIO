// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleEmergency {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public pendingWithdrawals; // Para almacenar retiros pendientes
    address public immutable owner;
    bool public emergencyActive;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }

    // ✅ Marcar fondos como pendientes en lugar de transferir (PULL)
    function emergencyWithdraw() public onlyOwner {
        require(!emergencyActive, "Emergency already active");
        uint256 contractBalance = address(this).balance;
        pendingWithdrawals[owner] += contractBalance; // Marcar como pendiente
        emergencyActive = true;
    }
    
    // ✅ Getter para pending withdrawals
    function getPendingWithdrawal() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }

    // ✅ Función para retirar fondos pendientes (patrón CEI)
    function withdrawPending() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No pending withdrawal");

        // CEI: Limpiar pending ANTES de transferir (evita reentrada)
        pendingWithdrawals[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}