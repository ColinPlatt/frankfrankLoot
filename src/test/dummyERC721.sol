// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.12;

import {ERC721} from "solmate/tokens/ERC721.sol";

contract DummyERC721 is ERC721 {

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return "token";
    }

    function mint(uint256 tokenId) public {
        _mint(msg.sender, tokenId);
    }
}