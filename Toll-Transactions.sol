// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TollCollection {
    struct TollData {
        uint timestamp;
        address collectedBy;
        uint amount;
    }

    // Mapping to store toll payments
    mapping(address => mapping(uint => TollData)) public tolls;

    // Events to log transaction status
    event TollPaymentSuccessful(address indexed payer, uint highwayId, uint amount, uint timestamp);
    event TollPaymentFailed(address indexed payer, string reason);

    // Payable function to handle toll payments
    function payTollAmount(uint highwayId) public payable {
        if (msg.value > 0) {
            tolls[msg.sender][highwayId].timestamp = block.timestamp;
            tolls[msg.sender][highwayId].collectedBy = msg.sender;
            tolls[msg.sender][highwayId].amount += msg.value;

            // Emit success event
            emit TollPaymentSuccessful(msg.sender, highwayId, msg.value, block.timestamp);
        } else {
            // Emit failure event
            emit TollPaymentFailed(msg.sender, "You must send some Ether to pay the toll");
        }
    }

    // Retrieve toll data for a specific highwayId
    function getToll(uint highwayId) public view returns (TollData memory) {
        return tolls[msg.sender][highwayId];
    }

    // Receive function to accept Ether
    receive() external payable {}

    // Fallback function for any undefined calls
    fallback() external payable {}
}
