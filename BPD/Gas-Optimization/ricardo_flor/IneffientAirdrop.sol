// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract IneffientAirdrop {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;
    uint256 public constant LIMIT_RECIPIENTS = 20; 
    
    function estimateAirdropGas(uint256 recipientCount) public pure returns (uint256) {
        // Aproximación: 30,000 gas base + 20,000 gas por destinatario
        require(recipientCount > 0, "Recipient count must be > 0");
        return 30000 + (recipientCount * 20000);
    }

    function airdrop(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "Amount should be greater than zero");
        require(recipients.length > 0, "First add addresses");
        require(recipients.length <= LIMIT_RECIPIENTS, "Too many recipients");
        for(uint i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += amount;
            totalSupply += amount;
        }
    }
}