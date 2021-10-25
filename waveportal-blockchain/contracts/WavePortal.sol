// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaveCount;
    address[] wavers;

    constructor() {
        console.log("WavePortalContractConstructor");
    }

    function wave() public {
        totalWaveCount += 1;
        wavers.push(msg.sender);
        console.log("%s has waved!", msg.sender);
    }

    function getTotalWaveCount() public view returns (uint256) {
        console.log("totalWaveCount: %d", totalWaveCount);
        return totalWaveCount;
    }

    function getWavers() public view returns (address[] memory) {
        return wavers;
    }
}
