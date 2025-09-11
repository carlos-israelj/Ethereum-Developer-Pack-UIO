// SPDX-License-Identifier: GPL-3.0
/*EJERCICIO 3: Funciones View y Pure
Objetivo
Convertir funciones innecesariamente costosas en versiones view/pure gratuitas.

Código Base*/
pragma solidity >=0.7.0 <0.9.0;

contract ExpensiveFunctions {
    mapping(address => uint256) public balances;
    uint256 public feePercent = 3;
    //uint256 public calculationResult; // ❌ Storage innecesario
    
    // PROBLEMA: Esta función MODIFICA storage solo para calcular
    function calculateFee(uint256 amount) public pure returns (uint256) {
        //calculationResult = amount * feePercent / 100; // ❌ Escritura costosa
        return amount * 3 / 100;
    }
    
    // PROBLEMA: Esta función MODIFICA storage para leer
    function getUserBalance(address user) public view returns (uint256) {
        //calculationResult = balances[user]; // ❌ Escritura innecesaria
        return balances[user];
    }
    
    // PROBLEMA: Esta función podría ser pure
    function isValidAmount(uint256 amount) public pure returns (bool) {
        return amount > 0 && amount <= 1000000; // No lee storage
    }
}

/*Tu Tarea
Convertir a pure: calculateFee() - solo calcula, no necesita storage
Convertir a view: getUserBalance() - solo lee, no modifica
Mejorar a pure: isValidAmount() - no necesita leer storage*/