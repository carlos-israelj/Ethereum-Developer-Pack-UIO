// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SecureBank {
    mapping(address => uint256) public balances;
    address public owner;
    mapping(address=> uint256) public pendingWithdrawals;
    bool private locked = false;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the owner!");
        _;
    }
    
    modifier nonReentrant() {
        require(locked != true, "No permitted");
        locked = true;
        _;
        locked = false;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }
    
    function initiateWithdrawal() public nonReentrant {
        uint256 amount = address(this).balance;
        pendingWithdrawals[msg.sender] += amount; 
    }
    
    function withdrawPending() public nonReentrant {
        uint256 amount = getPendingWithdrawal();
        
        require(amount > 0, "No pending withdrawal");
        
        pendingWithdrawals[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    function adminTransfer(address newOwner) public onlyOwner{
        require(newOwner != address(0), "New owner cannot be zero address");
        owner = newOwner;
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getPendingWithdrawal() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getTotalFunds() public view returns (uint256) {
        return address(this).balance;
    }
}