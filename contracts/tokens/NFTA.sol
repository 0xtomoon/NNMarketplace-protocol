// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NFTA is ERC721, ERC721Burnable {
    constructor() ERC721("NFTA Token", "NFTA") {
        for(uint i = 1; i <= 10; i++) {
            _safeMint(msg.sender, i);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://URI/";
    }
}
