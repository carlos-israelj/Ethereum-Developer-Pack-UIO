// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract EfficientFunctions {
    mapping(address => uint256) public balances;
    uint256 public constant feePercent = 3; // Mejor como constante (no cambia)
    
    // PURE: solo calcula, no toca storage
    function calculateFee(uint256 amount) public pure returns (uint256) {
        return (amount * 3) / 100; 
    }

    // VIEW: lee balances pero no modifica storage
    function getUserBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    // PURE: no usa storage ni variables de estado
    function isValidAmount(uint256 amount) public pure returns (bool) {
        return amount > 0 && amount <= 1_000_000;
    }
}
