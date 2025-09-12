// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleDeposits {
    uint256 public constant MIN_DEPOSIT = 0.01 ether;
    mapping(address => uint256) public balances;
    event Deposit(address indexed user, uint256 amount);
    
    // ✅ Solución: Validar que msg.value > 0
    function deposit() public payable {
        require(msg.value > 0, "SimpleDeposits: deposit amount must be greater than 0");
        require(msg.value >= MIN_DEPOSIT, "Deposit too low");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value); // ✅ Log del depósito
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}