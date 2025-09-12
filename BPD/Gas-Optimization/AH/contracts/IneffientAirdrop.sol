// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract IneffientAirdrop {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;

    uint256 public constant MAX_RECIPIENTS = 10;
    
    // PROBLEMA: ¿Qué pasa si recipients tiene 10,000 direcciones?
    function airdrop(address[] memory recipients, uint256 amount) public {
        require(recipients.length == 0, "No recipients");
        require(recipients.length >= MAX_RECIPIENTS, "Too many recipients");
        require(amount > 0, "Amount must be greater than 0");
        require(totalSupply >= amount * recipients.length, "Insufficient balance");

        for(uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            balances[recipients[i]] += amount;
            totalSupply += amount;
        }
    }

    // Función de estimación de gas
    function estimateAirdropGas(uint256 recipientCount) public pure returns (uint256) {
        require(recipientCount <= MAX_RECIPIENTS, "Too many recipients for estimation");
        
        // Gas base para la transacción
        uint256 baseGas = 30000;
        // Gas aproximado por cada destinatario (escritura en mapping)
        uint256 gasPerRecipient = 20000;
        
        return baseGas + (recipientCount * gasPerRecipient);
    }

}
