// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TransparentGasContract {
    mapping(address => uint256) public balances;
    
    // TODO: Agregar constantes para estimaciones
    uint256 public constant BASE_GAS = 21000;
    uint256 public constant GAS_PER_TRANSFER = 15000;
    uint256 public constant MAX_GAS_LIMIT = 300000;
    
    constructor() {
        balances[msg.sender] = 1000000; // Balance inicial para pruebas
    }
    
    // Función original que necesita optimización
    function batchTransfer(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must match");
        
        for(uint i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
        }
    }
    
    // TODO: Implementar función con límites de gas
    function safeBatchTransfer(address[] memory recipients, uint256[] memory amounts) public {
        // Agregar validaciones
        require(recipients.length == amounts.length, "Arrays must match");
        require(recipients.length <= 100, "Too many transfers");
        require(recipients.length > 0, "No recipients");
        // Verificar límite de gas
        uint256 gastToUsed = estimateBatchTransferGas(recipients.length);
        require(gastToUsed <= MAX_GAS_LIMIT, "Gas limit exceeded");
        // Ejecutar transferencias
        for(uint i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = amounts[i];
            
            require(recipient != address(0), "Invalid recipient");
            require(amount > 0, "Invalid amount");
            require(balances[msg.sender] >= amount, "Insufficient balance");
            
            // Effects-Interactions
            balances[msg.sender] -= amount;
            balances[recipient] += amount;
        }
    }
    
    // TODO: Implementar estimación básica
    function estimateBatchTransferGas(uint256 transferCount) public pure returns (uint256) {
        // Calcular gas base + gas por transferencia
        return (transferCount * GAS_PER_TRANSFER) + BASE_GAS;
    }
    
    // TODO: Implementar función de costos completa
    function getOperationCost(uint256 transferCount, uint256 gasPriceGwei) 
        public pure returns (
            uint256 gasEstimate,
            uint256 costWei,
            uint256 costGwei,
            uint256 costEther
        ) {
        // Retornar gas, costo en wei, gwei, ether
        gasEstimate = estimateBatchTransferGas(transferCount);
        costGwei = gasEstimate * gasPriceGwei;
        costWei = costGwei * 1e9; // gwei to wei
        costEther = costWei; // Para mostrar en formato ether (frontend divide por 1e18)
        
        return (gasEstimate, costWei, costGwei, costEther);
    }
    
    // TODO: Implementar función de viabilidad
    function isOperationViable(uint256 transferCount) public pure returns (bool viable, string memory reason) {
        // Verificar si la operación es viable
        uint256 gastToUsed = estimateBatchTransferGas(transferCount);
        if (gastToUsed > MAX_GAS_LIMIT) {
            return (false, "Operation exceeds gas limit");
        }
        
        if (transferCount == 0) {
            return (false, "No transfers to process");
        }
        
        return (true, "Operation is viable");
         
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
        public pure returns (
            uint256 gasEstimate,
            uint256 lowCost,    // 20 gwei
            uint256 mediumCost, // 50 gwei  
            uint256 highCost    // 100 gwei
        ) {
        // Esta función puede ser implementada como extensión
        gasEstimate = 21000 + (transferCount * 15000); // Estimación básica
        lowCost = gasEstimate * 20 * 1e9;
        mediumCost = gasEstimate * 50 * 1e9;
        highCost = gasEstimate * 100 * 1e9;
        
        return (gasEstimate, lowCost, mediumCost, highCost);
    }
    
    function getMaxTransfersForBudget(uint256 gasBudget) public pure returns (uint256) {
        if (gasBudget <= 21000) {
            return 0;
        }
        return (gasBudget - 21000) / 15000;
    }
}