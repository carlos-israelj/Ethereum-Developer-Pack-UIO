// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleOwnership {
    address public owner;

    // Modifier para restringir acceso solo al owner
    modifier onlyOwner() {
        require(msg.sender == owner, "SimpleOwnership: caller is not the owner");
        _; // Continúa con la ejecución de la función si pasa el check
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    // ✅ FIX: Only the current owner can change ownership
    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address"); // Prevent zero-address
        owner = newOwner;
    }
    
    // ❌ Removed `getOwner()`: `owner` is already `public`, so Solidity auto-generates a getter.
}