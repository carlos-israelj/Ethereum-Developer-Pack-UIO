// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleEmergency {
    mapping(address => uint256) public balances;
    address public owner;

    mapping(address => uint256) public pendingWithdrawals;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }
    
    function emergencyWithdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        pendingWithdrawals[msg.sender] += amount;        
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getPendingWithdrawal() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }

    function withdrawPending() public {
        uint256 amount = getPendingWithdrawal();
        
        require(amount > 0, "No pending withdrawal");
        
        pendingWithdrawals[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}