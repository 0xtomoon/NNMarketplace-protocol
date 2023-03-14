// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface INFTB is IERC1155 {
    /**
     * @dev Mint ERC1155 token
     */
    function mint(address to, uint256 id, uint256 amount, bytes memory data) external;
}