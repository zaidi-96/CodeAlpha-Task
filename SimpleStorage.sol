// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint public value; // Stores an integer value

    // Increments value by 1
    function increment() public {
        value += 1;
    }

    // Decrements value by 1
    function decrement() public {
        value -= 1;
    }

    // The 'public' keyword already allows reading 'value' from outside
}
