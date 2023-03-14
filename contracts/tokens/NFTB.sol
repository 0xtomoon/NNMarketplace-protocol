// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTB is ERC1155, Ownable {
    mapping (uint256 => string) private _uris;
    string public name = "NFTB Token";
    string public symbol = "NFTB";
    address public marketplace;

    modifier onlyMarketplace() {
        require(msg.sender == marketplace, "The NFT is not currently available for sale");
        _;
    }

    constructor() ERC1155("") {

    }

    function setMarketplace(address _marketplace) public onlyOwner {
        marketplace = _marketplace;
    }

    function uri(uint256 tokenId) override public view returns (string memory) {
        return(_uris[tokenId]);
    }

    function setTokenUri(uint256 tokenId, string memory _uri) public onlyMarketplace {
        _uris[tokenId] = _uri;
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyMarketplace
    {
        _mint(account, id, amount, data);
    }
}
