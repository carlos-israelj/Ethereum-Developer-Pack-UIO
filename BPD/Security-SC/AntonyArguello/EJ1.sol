/*🚀 EJERCICIO 1: Control de Acceso
🎯 Objetivo
Aprender a proteger funciones críticas para que solo personas autorizadas puedan ejecutarlas.

📁 Setup
Archivo: contracts/Exercise1_AccessControl.sol*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleOwnership {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    // 🚨 PROBLEMA: ¿Quién puede cambiar el owner actualmente?
    //Cualquiera
    function changeOwner(address newOwner) public {
        //Aqui solo el owner puede cambiar
        require(msg.sender==owner);
        owner = newOwner;
    }
    
    function getOwner() public view returns (address) {
        return owner;
    }
}
