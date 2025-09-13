// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ExpensiveFunctions {
    mapping(address => uint256) public balances;
    uint256 public constant feePercent = 3;
    
    function calculateFee(uint256 amount) public pure returns (uint256) {
        return amount * feePercent / 100;         
    }
    
    function getUserBalance(address user) public view returns (uint256) {
        return balances[user];
    }
    
    function isValidAmount(uint256 amount) public pure returns (bool) {
        return amount > 0 && amount <= 1000000;
    }
}