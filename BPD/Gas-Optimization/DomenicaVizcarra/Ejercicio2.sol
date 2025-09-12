// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract EfficientStorage {
    // SLOT 1: uint256 ocupa un slot completo
    uint256 public largeNumber;  

    // SLOT 2: dos uint128 juntos = 16 + 16 = 32 bytes
    uint128 public mediumNumber;
    uint128 public anotherMedium;

    // SLOT 3: address (20 bytes) + bool (1 byte) + bool (1 byte)
    // = 22 bytes (10 libres, pero en el mismo slot)
    address public owner;
    bool public isActive;
    bool public isPaused;
}
