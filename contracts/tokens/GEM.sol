// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GEM is ERC20, ERC20Burnable {
    constructor() ERC20("GEM Token", "GEM") {
        // mint 1B token
        _mint(msg.sender, 10**27);
    }
}
