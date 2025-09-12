// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract IneffientStorage {
    // PROBLEMA: Cada variable usa un slot completo de 32 bytes
    // bool public isActive;        // Usa 1 bytes, desperdicia 31
    // uint256 public largeNumber;  // Usa 32 bytes ✓
    // uint128 public mediumNumber; // Usa 16 bytes, desperdicia 16
    // bool public isPaused;        // Usa 1 bytes, desperdicia 31
    // uint128 public anotherMedium;// Usa 16 bytes, desperdicia 16
    // address public owner;        // Usa 20 bytes, desperdicia 12
    
    // Total: 6 slots = gas caro para escribir/leer

    // SLOT 1 (32 bytes): uint256 solo
    uint256 public largeNumber;  // 32 bytes
    
    // SLOT 2 (32 bytes):
    uint128 public mediumNumber;     // 16 bytes
    uint128 public anotherMedium;    // 16 bytes
    // Total slot 2: 32 bytes ✓
    
    // SLOT 3 (32 bytes):
    address public owner;        // 20 bytes
    bool public isActive;        // 1 byte
    bool public isPaused;        // 1 byte
    // Total slot 3: 22 bytes
}