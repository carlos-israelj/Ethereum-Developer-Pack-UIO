// SPDX-License-Identifier: GPL-3.0
/*EJERCICIO 2: Eficiencia de Tipos de Datos
Objetivo
Optimizar el storage de un contrato reorganizando variables para usar menos slots.

Código Base*/
pragma solidity >=0.7.0 <0.9.0;

contract IneffientStorage {
    // PROBLEMA: Cada variable usa un slot completo de 32 bytes

    uint256 public largeNumber; // Usa 32 bytes ✓
    uint128 public mediumNumber; // 
    uint128 public anotherMedium; // Usa 32 bytes ✓,
    address public owner; // 
    bool public isPaused; // 
    bool public isActive; // Usa 32 bytes, desperdicia 10

    // Total: 6 slots = gas caro para escribir/leer
}
/*
Tu Tarea
Reorganizar variables para minimizar slots de storage
Mantener funcionalidad - solo cambiar el orden/agrupación*/
