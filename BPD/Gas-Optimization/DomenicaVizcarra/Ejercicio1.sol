// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract OptimizedAirdrop {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;

    // Límite de destinatarios para evitar out-of-gas
    uint256 public constant MAX_RECIPIENTS = 100;  

    // Función optimizada
    function airdrop(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "El monto debe ser mayor que cero");
        require(recipients.length > 0, "No hay direcciones");
        require(recipients.length <= MAX_RECIPIENTS, "Muchas direcciones");

        // Guardar en memoria para ahorrar gas
        uint256 len = recipients.length;

        for (uint256 i = 0; i < len; i++) {
            balances[recipients[i]] += amount;
        }

        // Ajuste del totalSupply
        totalSupply += amount * len;
    }

    // Estimación de gas para transparencia
    function estimateAirdropGas(uint256 recipientCount) public pure returns (uint256) {
        require(recipientCount > 0, "Recipient count must be > 0");
        // Aproximación: 30,000 gas base + 20,000 por destinatario
        return 30000 + (20000 * recipientCount);
    }
}
