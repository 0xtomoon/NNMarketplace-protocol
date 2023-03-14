// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MKP is ERC20 {
    constructor() ERC20("Marketplace Token", "MKP") {
        // mint 1M token
        _mint(msg.sender, 10**24);
    }
}
