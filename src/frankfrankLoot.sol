// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.12;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC2981} from "./ERC2981.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";


interface IFrank {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}


/// @title Frank
/// @author frank
contract FrankFrankLoot is ERC721, ERC2981 {
    using Strings for uint256;
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    IFrank public immutable frank = IFrank(0x91680cF5F9071cafAE21B90ebf2c9CC9e480fB93);

    uint256 public SEED;

    string[] private franks = [
        "frank",
        "FRANK",
        "frank ", 
        "FRANK "
    ];

    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor()
    ERC721("frankLoot", "FRANKLOOT") {
        _royaltyFee = 700;
        _royaltyRecipient = msg.sender;
        SEED = random(block.timestamp);
    }

    /*//////////////////////////////////////////////////////////////
                        FRANKLY INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(SEED, input)));
    }

    function franksPerLine(uint256 _tokenId, uint256 _line) internal view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked(SEED, _tokenId.toString())));
        uint256 greatness = rand % 21;

        if (greatness > 7) {
            return random(string(abi.encodePacked(_line.toString(), _tokenId.toString()))) % 4 + 2;
        } else {
            return 1;
        }

    }

    function pluckLine(uint256 tokenId, uint256 line) internal view returns (string memory) {
        uint256 franksThisLine = franksPerLine(tokenId, line);

        string memory output;

        for(uint256 i = 0; i < franksThisLine; i++) {
            uint256 rand = random(string(abi.encodePacked(SEED, i, line, tokenId.toString())));
            output = string(abi.encodePacked(output, franks[rand % franks.length]));
        }
    }

    // all should have 8 lines, each line will have between 1 and 7 franks
    // lines can be static or can be animated


    /*//////////////////////////////////////////////////////////////
                        FRANKLY PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function mintWithFrank(uint256 frankId) public payable {
        require(frankId >= 0 && frankId < 2000, "FRANKLY_INVALID");
        require(frank.ownerOf(frankId) == msg.sender, "FRANKLY_NOT_YOURS");
        _safeMint(msg.sender, frankId);
    }

    function mintWithFrank(uint256[] memory frankId) public payable {
        uint256 frankfranks = frankId.length;
        for (uint256 i = 0; i < frankfranks; i++) {
            require(frankId[i] >= 0 && frankId[i] < 2000, "FRANKLY_INVALID");
            require(frank.ownerOf(frankId[i]) == msg.sender, "FRANKLY_NOT_YOURS");
           _safeMint(msg.sender, frankId[i]);
        }
    }


    /*//////////////////////////////////////////////////////////////
                        FRANKLY VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory output;
        
        return output;
    }

    function supportsInterface(bytes4 interfaceId) public pure override(ERC721, ERC2981) returns (bool) {
        return ERC721.supportsInterface(interfaceId);
    }
}