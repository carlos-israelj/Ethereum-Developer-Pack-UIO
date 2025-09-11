/*EJERCICIO 4: Sistema de Estimaciones de Gas
Objetivo
Crear un sistema completo que informe a los usuarios sobre costos antes de ejecutar operaciones.

Código Base*/
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TransparentGasContract {
    mapping(address => uint256) public balances;

    // TODO: Agregar constantes para estimaciones
    uint256 public constant BASE_GAS = 1000000;
    uint256 public constant GAS_PER_TRANSFER = 500;
    uint256 public constant MAX_GAS_LIMIT = 100000000;

    constructor() {
        balances[msg.sender] = 1000000; // Balance inicial para pruebas
    }

    // Función original que necesita optimización
    function batchTransfer(
        address[] memory recipients,
        uint256[] memory amounts
    ) public {
        require(recipients.length == amounts.length, "Arrays must match");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
        }
    }

    // TODO: Implementar función con límites de gas
    function safeBatchTransfer(
        address[] memory recipients,
        uint256[] memory amounts
    ) public {
        // Agregar validaciones
        require(recipients.length == amounts.length, "Arrays must match");
        (bool viable, string memory reason) = isOperationViable(
            recipients.length
        );
        require(viable,reason);
        // Ejecutar transferencias
        for (uint256 i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
        }
    }

    //TODO: Implementar estimación básica
    function estimateBatchTransferGas(uint256 transferCount)
        public
        pure
        returns (uint256)
    {
        // Calcular gas base + gas por transferencia
        return BASE_GAS + (transferCount * GAS_PER_TRANSFER);
    }

    // TODO: Implementar función de costos completa
    function getOperationCost(uint256 transferCount, uint256 gasPriceGwei)
        public
        pure
        returns (
            uint256 gasEstimate,
            uint256 weiP,
            uint256 gweiP,
            uint256 etherP
        )
    {
        gasEstimate = estimateBatchTransferGas(transferCount);
        // Retornar gas, costo en wei, gwei, ether
        uint256 gasWei = gasPriceGwei * 1e9;
        weiP = gasEstimate * gasWei;
        gweiP = weiP / 1e9;
        etherP = weiP / 1e18;
        return (gasEstimate, weiP, gweiP, etherP);
    }

    // TODO: Implementar función de viabilidad
    function isOperationViable(uint256 transferCount)
        public
        pure
        returns (bool viable, string memory reason)
    {
        uint256 gasNeed = estimateBatchTransferGas(transferCount);
        if (gasNeed > MAX_GAS_LIMIT) {
            return (false, "Max gas pass");
        }
        return (true, "Viable");
        // Verificar si la operación es viable
    }

    // Funciones auxiliares para testing
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function setBalance(address user, uint256 amount) public {
        balances[user] = amount;
    }

    function getMultiplePriceEstimates(uint256 transferCount)
        public
        pure
        returns (
            uint256 gasEstimate,
            uint256 lowCost, // 20 gwei
            uint256 mediumCost, // 50 gwei
            uint256 highCost // 100 gwei
        )
    {
        // Esta función puede ser implementada como extensión
        gasEstimate = 21000 + (transferCount * 15000); // Estimación básica
        lowCost = gasEstimate * 20 * 1e9;
        mediumCost = gasEstimate * 50 * 1e9;
        highCost = gasEstimate * 100 * 1e9;

        return (gasEstimate, lowCost, mediumCost, highCost);
    }

    function getMaxTransfersForBudget(uint256 gasBudget)
        public
        pure
        returns (uint256)
    {
        if (gasBudget <= 21000) {
            return 0;
        }
        return (gasBudget - 21000) / 15000;
    }
}

/*Tu Tarea
Crear función de estimación de gas para batchTransfer
Agregar límites basados en gas estimado
Función de transparencia que muestre costo en diferentes unidades*/
