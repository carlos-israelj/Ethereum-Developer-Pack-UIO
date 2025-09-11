/*EJERCICIO 1: Refactorización para Claridad y Mantenibilidad
Objetivo
Transformar código confuso en código profesional y mantenible.

Contexto
Has heredado este contrato de un desarrollador que ya no está en el equipo. Necesitas mantenerlo y agregar nuevas funcionalidades, pero el código es imposible de entender.

Código Base - Contrato Confuso*/
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract BadShop {
    mapping(address => uint256) balance;
    mapping(uint256 => address) owner;
    mapping(uint256 => uint256) prices;
    mapping(uint256 => bool) shopeable;
    uint256 c;
    address admin;

    constructor() {
        admin = msg.sender;
    }

    function create(uint256 price) public {
        require(msg.sender != address(0));
        c++;
        owner[c] = msg.sender;
        prices[c] = price;
        shopeable[c] = true;
    }

    function buy(uint256 id) public payable {
        require(
            shopeable[id] && msg.value >= prices[id] && msg.sender != owner[id]
        );
        transfer(owner[id]);
        shopeable[id] = false;
    }

    function retirar() public {
        require(msg.sender == admin);
        payable(admin).transfer(address(this).balance);
    }

    function getBalance(address u) public view returns (uint256) {
        return balance[u];
    }

    function getShopeable(uint256 id) public view returns (bool) {
        return shopeable[id];
    }

    function transfer(address _owner) public payable {
        payable(_owner).transfer(msg.value);
    }
}
/*
Tu Tarea (30 minutos máximo)
Renombrar variables y funciones con nombres que expliquen su propósito
Agregar comentarios NatSpec para documentar el contrato
Organizar código con estructura clara (variables, events, modifiers, funciones)
Separar la función compleja f2() en partes más pequeñas*/
