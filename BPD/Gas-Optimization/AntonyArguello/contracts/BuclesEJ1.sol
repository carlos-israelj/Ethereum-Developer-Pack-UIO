// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract IneffientAirdrop {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;

    // PROBLEMA: ¿Qué pasa si recipients tiene 10,000 direcciones?
    function airdrop(address[] memory recipients, uint256 amount) public {
        estimateTransferCost(recipients);
        require(recipients.length > 100, "recipiente demasiado largo");
        for (uint256 i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += amount;
            totalSupply += amount;
        }
    }

    function estimateTransferCost(address[] memory recipients)
        public
        pure
        returns (uint256)
    {
        return 21000 + (recipients.length * 5000);
    }
}
/*Tu Tarea
Identificar el problema: ¿Por qué esta función puede fallar?
Optimizar la función: Agregar límites y validaciones
Agregar transparencia: Función para estimar gas*/
