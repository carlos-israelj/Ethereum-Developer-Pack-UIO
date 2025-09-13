// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TransparentGasContract {
    mapping(address => uint256) public balances;

    // Constantes de estimación de gas
    uint256 public constant BASE_GAS = 21000;
    uint256 public constant GAS_PER_TRANSFER = 15000;
    uint256 public constant MAX_GAS_LIMIT = 300000;

    constructor() {
        balances[msg.sender] = 1000000; // Balance inicial para pruebas
    }


    function safeBatchTransfer(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must match");
        uint256 transferCount = recipients.length;
        require(transferCount > 0, "No transfers");

        // 1. Estimar gas
        uint256 estimatedGas = estimateBatchTransferGas(transferCount);

        // 2. Verificar límite
        require(estimatedGas <= MAX_GAS_LIMIT, "Operation too expensive");

        // 3. Ejecutar transferencias (misma lógica que batchTransfer)
        for (uint i = 0; i < transferCount; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
        }
    }


    function estimateBatchTransferGas(uint256 transferCount) public pure returns (uint256 totalGas) {
        totalGas = BASE_GAS + (transferCount * GAS_PER_TRANSFER);
        return totalGas;
    }


    function getOperationCost(uint256 transferCount, uint256 gasPriceGwei)
        public
        pure
        returns (
            uint256 gasEstimate,
            uint256 costWei,
            uint256 costGwei,
            uint256 costEther
        )
    {
        gasEstimate = estimateBatchTransferGas(transferCount);

        // costWei = gasEstimate * gasPriceGwei * 1e9
        // Evitamos desbordes razonables dados los tamaños usados en los tests
        costGwei = gasEstimate * gasPriceGwei; // total en Gwei
        costWei = costGwei * 1e9; // convertir Gwei -> Wei
        costEther = costWei / 1e18; // convertir Wei -> Ether (truncado)

        return (gasEstimate, costWei, costGwei, costEther);
    }


    function isOperationViable(uint256 transferCount) public pure returns (bool viable, string memory reason) {
        if (transferCount == 0) {
            return (false, "No transfers requested");
        }
        uint256 estimatedGas = estimateBatchTransferGas(transferCount);
        if (estimatedGas > MAX_GAS_LIMIT) {
            return (false, "Estimated gas exceeds maximum limit");
        }
        return (true, "Operation is viable");
    }

    // Funciones auxiliares para testing

    // Deposita Ether en el "balance" interno del contrato para pruebas.

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Obtiene balance interno de un usuario.

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    // Fija manualmente el balance de un usuario (para testing).

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
        gasEstimate = BASE_GAS + (transferCount * GAS_PER_TRANSFER);
        lowCost = gasEstimate * 20 * 1e9;
        mediumCost = gasEstimate * 50 * 1e9;
        highCost = gasEstimate * 100 * 1e9;

        return (gasEstimate, lowCost, mediumCost, highCost);
    }


    function getMaxTransfersForBudget(uint256 gasBudget) public pure returns (uint256) {
        if (gasBudget <= BASE_GAS) {
            return 0;
        }
        return (gasBudget - BASE_GAS) / GAS_PER_TRANSFER;
    }
}
