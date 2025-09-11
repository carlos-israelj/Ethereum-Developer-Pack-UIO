/*🚀 EJERCICIO 3: Patrón CEI (Checks-Effects-Interactions)
🎯 Objetivo
Aprender el orden correcto para escribir funciones seguras y prevenir ataques de reentrada.

📁 Setup
Archivo: contracts/Exercise3_CEIPattern.sol
*/
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleWithdrawals {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }
    
    // 🚨 PROBLEMA: ¿Ves algún problema con el ORDEN de estas operaciones?
    function withdraw(uint256 amount) public {
        //CHECK
        require(balances[msg.sender] >= amount, "Insufficient balance");
        //Effects
        balances[msg.sender] -= amount;
        //Interactions
        // ❌ PELIGRO: ¿Qué pasa si esta línea permite al receptor llamar withdraw() otra vez?
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        // ❌ PROBLEMA: ¿Esta actualización llega muy tarde?
       // balances[msg.sender] -= amount;
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}