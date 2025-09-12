// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20; // Versión específica para evitar problemas

contract SecureBank {
    // ✅ Variables necesarias
    mapping(address => uint256) private balances;
    mapping(address => uint256) private pendingWithdrawals;
    address private immutable owner;
    uint256 private totalFunds;
    bool private locked; // Para nonReentrant

    // ✅ Eventos para transparencia
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event PendingWithdrawalInitiated(address indexed user, uint256 amount);
    event PendingWithdrawalCompleted(address indexed user, uint256 amount);
    event EmergencyWithdrawal(address indexed owner, uint256 amount);
    event AdminTransfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // ✅ Modifiers necesarios
    modifier onlyOwner() {
        require(msg.sender == owner, "SecureBank: caller is not the owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "SecureBank: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // ✅ Funciones core
    function deposit() public payable nonReentrant {
        require(msg.value > 0, "SecureBank: deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public nonReentrant {
        require(amount > 0, "SecureBank: amount must be greater than 0");
        require(balances[msg.sender] >= amount, "SecureBank: insufficient balance");

        // CEI: Effects antes de Interactions
        balances[msg.sender] -= amount;
        totalFunds -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "SecureBank: transfer failed");

        emit Withdrawal(msg.sender, amount);
    }

    // Patrón Pull - Paso 1: Iniciar retiro
    function initiateWithdrawal(uint256 amount) public nonReentrant {
        require(amount > 0, "SecureBank: amount must be greater than 0");
        require(balances[msg.sender] >= amount, "SecureBank: insufficient balance");

        // CEI: Actualizar estados antes de cualquier interacción
        balances[msg.sender] -= amount;
        pendingWithdrawals[msg.sender] += amount;
        totalFunds -= amount;

        emit PendingWithdrawalInitiated(msg.sender, amount);
    }

    // Patrón Pull - Paso 2: Retirar fondos pendientes
    function withdrawPending() public nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "SecureBank: no pending withdrawal");

        // CEI: Limpiar pending antes de transferir
        pendingWithdrawals[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "SecureBank: transfer failed");

        emit PendingWithdrawalCompleted(msg.sender, amount);
    }

    // ✅ Funciones Admin
    function emergencyWithdraw() public onlyOwner nonReentrant {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "SecureBank: no funds to withdraw");

        // Patrón Pull: Marcar como pendiente en lugar de transferir
        pendingWithdrawals[owner] += contractBalance;
        totalFunds = 0; // Todos los fondos están ahora como pendientes

        emit EmergencyWithdrawal(owner, contractBalance);
    }

    function adminTransfer(address from, address to, uint256 amount) public onlyOwner nonReentrant {
        // Validaciones completas
        require(from != address(0), "SecureBank: invalid from address");
        require(to != address(0), "SecureBank: invalid to address");
        require(from != to, "SecureBank: cannot transfer to self");
        require(amount > 0, "SecureBank: amount must be greater than 0");
        require(balances[from] >= amount, "SecureBank: insufficient balance");

        // CEI: Actualizar estados antes de cualquier efecto
        balances[from] -= amount;
        balances[to] += amount;

        emit AdminTransfer(from, to, amount);
    }

    // ✅ Funciones View
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getPendingWithdrawal() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getTotalFunds() public view onlyOwner returns (uint256) {
        return totalFunds;
    }
}