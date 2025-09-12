// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "remix_tests.sol";
import "./contracts/TransparentGasContract.sol";

contract TestExercise4 {
    TransparentGasContract gasContract;
    
    function beforeEach() public {
        gasContract = new TransparentGasContract();
    }
    
    /// Test: Debe existir función de estimación
    function testEstimationExists() public {
        uint256 estimate = gasContract.estimateBatchTransferGas(5);
        Assert.ok(estimate > 0, "Should provide gas estimation");
    }
    
    /// Test: Debe rechazar operaciones muy costosas
    function testRejectExpensiveOperations() public {
        // Crear arrays grandes que excedan el límite
        address[] memory manyRecipients = new address[](50);
        uint256[] memory amounts = new uint256[](50);
        
        for(uint i = 0; i < 50; i++) {
            manyRecipients[i] = address(uint160(i + 1));
            amounts[i] = 100;
        }
        
        try gasContract.safeBatchTransfer(manyRecipients, amounts) {
            Assert.ok(false, "Should reject expensive operations");
        } catch Error(string memory reason) {
            Assert.ok(true, "Correctly rejects expensive operations");
        }
    }
    
    /// Test: Debe proveer información de costos completa
    function testCostInformation() public {
        (uint256 gas, uint256 costWei, uint256 costGwei, uint256 costEther) = 
            gasContract.getOperationCost(3, 50);
        
        Assert.ok(gas > 0, "Should provide gas estimate");
        Assert.ok(costWei > 0, "Should provide cost in wei");
        Assert.ok(costGwei > 0, "Should provide cost in gwei");
    }
    
    /// Test: Función de viabilidad debe funcionar
    function testViabilityCheck() public {
        (bool viable, string memory reason) = gasContract.isOperationViable(5);
        Assert.ok(viable, "Small operations should be viable");
        
        (bool notViable, ) = gasContract.isOperationViable(0);
        Assert.ok(!notViable, "Zero transfers should not be viable");
    }
    
    /// Test: Transferencias válidas deben funcionar
    /// #value: 1000000000000000000
    function testValidTransfers() public payable {
        gasContract.deposit{value: 1 ether}();
        
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](2);
        
        recipients[0] = address(0x123);
        recipients[1] = address(0x456);
        amounts[0] = 100;
        amounts[1] = 200;
        
        gasContract.safeBatchTransfer(recipients, amounts);
        
        Assert.equal(gasContract.getBalance(recipients[0]), 100, "Should transfer correctly");
    }
}