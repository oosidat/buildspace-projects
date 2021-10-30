// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    uint256 totalWaveCount;
    Wave[] waves;

    constructor() {
        console.log("WavePortalContractConstructor");
    }

    function wave(string memory _message) public {
        totalWaveCount += 1;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));
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
