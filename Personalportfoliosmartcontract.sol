// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoLock {
    mapping(address => uint) public deposits;
    mapping(address => uint) public unlockTimes;

    function deposit(uint lockTime) public payable {
        require(msg.value > 0, "Must deposit Ether");
        deposits[msg.sender] += msg.value;
        unlockTimes[msg.sender] = block.timestamp + lockTime;
    }

    function withdraw() public {
        require(block.timestamp >= unlockTimes[msg.sender], "Lock time not passed");
        uint amount = deposits[msg.sender];
        require(amount > 0, "No funds to withdraw");
        deposits[msg.sender] = 0;
        unlockTimes[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
