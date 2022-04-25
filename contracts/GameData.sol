// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameData {
    struct Fighter {
        uint256 fighterId;
        uint256 xp;
        uint256 energy;
        uint256 energyMax;
    }
}