// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleWithdrawals {
    mapping(address => uint256) public balances;
    event Withdrawn(address indexed user, uint256 amount);
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }
    
    // ✅ Solución: Aplicar patrón CEI (Checks -> Effects -> Interactions)
    function withdraw(uint256 amount) public {
        // 1. CHECKS: Validar condiciones previas
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // 2. EFFECTS: Actualizar el estado del contrato ANTES de interacciones externas
        balances[msg.sender] -= amount;

        // 3. INTERACTIONS: Interactuar con contratos externos (lo último)
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}