// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TransparentGasContract {
    mapping(address => uint256) public balances;

    // Constantes para cálculos de gas
    uint256 public constant BASE_GAS = 21000;
    uint256 public constant GAS_PER_TRANSFER = 15000;
    uint256 public constant MAX_GAS_LIMIT = 300000; // límite preventivo

    constructor() {
        balances[msg.sender] = 1000000; // Balance inicial de prueba
    }

    // Estimación de gas
    function estimateBatchTransferGas(uint256 transferCount) public pure returns (uint256) {
        return BASE_GAS + (transferCount * GAS_PER_TRANSFER);
    }

    // Transferencia segura con límite
    function safeBatchTransfer(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must match");
        require(recipients.length > 0, "Must have at least one transfer");

        uint256 estimatedGas = estimateBatchTransferGas(recipients.length);
        require(estimatedGas <= MAX_GAS_LIMIT, "Operation too expensive");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
        }
    }

    // Información de costos
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

        // Convertir gas price a wei
        uint256 gasPriceWei = gasPriceGwei * 1e9;

        // Costos en distintas unidades
        costWei = gasEstimate * gasPriceWei;
        costGwei = costWei / 1e9;
        costEther = costWei / 1e18;
    }

    // Chequeo de viabilidad
    function isOperationViable(uint256 transferCount) public pure returns (bool viable, string memory reason) {
        if (transferCount == 0) {
            return (false, "No transfers requested");
        }

        uint256 estimatedGas = estimateBatchTransferGas(transferCount);
        if (estimatedGas > MAX_GAS_LIMIT) {
            return (false, "Operation exceeds gas limit");
        }

        return (true, "Operation is viable");
    }

    // Funciones auxiliares
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function setBalance(address user, uint256 amount) public {
        balances[user] = amount;
    }

    // Extensión: estimaciones rápidas
    function getMultiplePriceEstimates(uint256 transferCount)
        public
        pure
        returns (
            uint256 gasEstimate,
            uint256 lowCost,    // 20 gwei
            uint256 mediumCost, // 50 gwei
            uint256 highCost    // 100 gwei
        )
    {
        gasEstimate = estimateBatchTransferGas(transferCount);
        lowCost = gasEstimate * 20 * 1e9;
        mediumCost = gasEstimate * 50 * 1e9;
        highCost = gasEstimate * 100 * 1e9;
    }

    function getMaxTransfersForBudget(uint256 gasBudget) public pure returns (uint256) {
        if (gasBudget <= BASE_GAS) {
            return 0;
        }
        return (gasBudget - BASE_GAS) / GAS_PER_TRANSFER;
    }
}
