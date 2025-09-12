// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleOwnership {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }

    // Modifier para restringir acceso
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    // Solo el owner puede cambiar ownership
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function getOwner() public view returns (address) {
        return owner;
    }
}
