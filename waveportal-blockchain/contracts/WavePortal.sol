// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 private prizeWinnerRandomizerSeed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    uint256 totalWaveCount;
    Wave[] waves;
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("WavePortalContractConstructor");
        prizeWinnerRandomizerSeed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s please"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaveCount += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        prizeWinnerRandomizerSeed = (block.timestamp + block.difficulty) % 100;

        if (prizeWinnerRandomizerSeed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.00005 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more $$$ than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw $$$ from contract");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaveCount() public view returns (uint256) {
        console.log("totalWaveCount: %d", totalWaveCount);
        return totalWaveCount;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}
