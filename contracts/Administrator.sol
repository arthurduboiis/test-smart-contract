// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Administrator is Ownable {
    mapping(address => bool) private addressIsAdmin;
    bool private isActive = true;
    bool private isWhitelistActive = true;

    modifier onlyAdmin() {
        require(
            msg.sender == owner() || addressIsAdmin[msg.sender],
            "Sender is not admin"
        );
        _;
    }

    modifier contractIsActive() {
        require(isActive, "Contract is not active");
        _;
    }

    modifier whitelistIsActive() {
        require(isWhitelistActive, "Whitelist is not active");
        _;
    }

    function addAdmin(address adminAddress) public onlyOwner {
        addressIsAdmin[adminAddress] = true;
    }

    function removeAdmin(address adminAddress) public onlyOwner {
        addressIsAdmin[adminAddress] = false;
    }

    function pauseContract() public onlyOwner {
        isActive = false;
    }

    function activateContract() public onlyOwner {
        isActive = false;
    }

    function stopWhitelist() public onlyAdmin {
        isWhitelistActive = false;
    }

    function activateWhitelist() public onlyAdmin {
        isWhitelistActive = true;
    }
}
