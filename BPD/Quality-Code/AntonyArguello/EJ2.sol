/*EJERCICIO 2: Análisis Básico de Contratos Actualizables
Objetivo
Entender la diferencia básica entre contratos inmutables y actualizables.

Contexto
Tu jefe te pregunta: "¿Deberíamos hacer nuestro token actualizable o inmutable?" Necesitas darle una respuesta simple.

Código Base - Comparación Simple*/
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// OPCIÓN A: Token Inmutable (no se puede cambiar)
contract ImmutableToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;
    
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    // ¿Qué pasa si hay un bug aquí? ¿Podemos arreglarlo?
    // Respuesta: NO, está grabado en piedra
}

// OPCIÓN B: Token con Admin (se puede cambiar)
contract AdminToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 1000000;
    address public admin;
    
    constructor() {
        admin = msg.sender;
    }
    
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    // Admin puede cambiar cualquier balance
    function adminSetBalance(address user, uint256 newBalance) public {
        require(msg.sender == admin, "Only admin");
        balances[user] = newBalance; // ¿Es esto bueno o malo?
    }
    
    // Admin puede pausar transfers
    function adminPauseTransfers() public {
        require(msg.sender == admin, "Only admin");
        // Código para pausar... ¿Qué opinas de este poder?
    }
}
/*
Tu Tarea (15 minutos máximo)
Completa esta tabla simple:

| Aspecto | Token Inmutable | Token con Admin |
|---------|----------------|-----------------|
| ¿Puede corregir bugs? | [NO] | [SÍ] |
| ¿Puede robar fondos? | [NO] | [SÍ] |
| ¿Los usuarios confían siempre? | [SÍ] | [NO] |
| ¿Puede agregar funciones nuevas? | [NO] | [SÍ] |
| ¿Es descentralizado? | [SÍ] | [NO] |
Pregunta Simple
¿Cuál elegirías para cada caso?

Para Bitcoin: [Inmutable] - ¿Por qué?
Bitcoin es usando para resgurdar valor frente a la inflacion y la confianza que da es porque esta escrito en piedra.
Para un juego experimental: [Admin] - ¿Por qué?
Al ser experimental puede experimentar multiples bugs que necesitarian ser arreglados.
Para ahorros de jubilación: [Inmutable] - ¿Por qué?
Al igual que bitcoin estos ahorros deben ser preservados en el tiempo sin que nadie sea responsable mas que el propio dueño.
*/