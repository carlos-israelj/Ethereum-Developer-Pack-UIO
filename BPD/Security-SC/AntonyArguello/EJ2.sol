/*🚀 EJERCICIO 2: Validación de Entradas
🎯 Objetivo
Aprender a validar que las entradas a las funciones sean válidas antes de procesarlas.

📁 Setup
Archivo: contracts/Exercise2_InputValidation.sol
*/
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleDeposits {
    mapping(address => uint256) public balances;
    
    // 🚨 PROBLEMA: ¿Qué pasa si alguien "deposita" 0 ETH?
    function deposit() public payable {
        require(msg.value>0);
        balances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}