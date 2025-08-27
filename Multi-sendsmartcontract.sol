// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSend {
    // Payable function that receives Ether and distributes it equally
    function sendEther(address[] calldata recipients) external payable {
        // Check if there are recipients
        require(recipients.length > 0, "No recipients provided");
        
        // Calculate equal amount for each recipient
        uint256 amountPerRecipient = msg.value / recipients.length;
        
        // Check if the amount is sufficient
        require(amountPerRecipient > 0, "Insufficient Ether sent");
        
        // Send Ether to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            // Use call instead of transfer for better compatibility
            (bool success, ) = recipients[i].call{value: amountPerRecipient}("");
            require(success, "Transfer failed");
        }
        
        // Return any leftover wei to the sender (due to integer division)
        uint256 leftover = msg.value - (amountPerRecipient * recipients.length);
        if (leftover > 0) {
            (bool success, ) = msg.sender.call{value: leftover}("");
            require(success, "Refund of leftover Ether failed");
        }
    }
}