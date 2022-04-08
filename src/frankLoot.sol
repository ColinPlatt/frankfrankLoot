// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.12;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC2981} from "./ERC2981.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";


interface IFrank {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}


/// @title Frank
/// @author frank
contract FrankLoot is ERC721, ERC2981 {
    using Strings for uint256;
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    //IFrank public immutable frank = IFrank(0x91680cF5F9071cafAE21B90ebf2c9CC9e480fB93);
    IFrank public frank;

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

    constructor(address _frank)
    ERC721("frankLoot", "FRANKLOOT") {
        frank = IFrank(_frank);
        _royaltyFee = 700;
        _royaltyRecipient = msg.sender;
        SEED = random(block.timestamp.toString());
    }

    /*//////////////////////////////////////////////////////////////
                        FRANKLY INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function random(string memory input) internal view returns (uint256) {
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

    function getLine(uint256 tokenId, uint256 line) internal view returns (string memory) {
        uint256 franksThisLine = franksPerLine(tokenId, line);

        string memory output;

        for(uint256 i = 0; i < franksThisLine; i++) {
            uint256 rand = random(string(abi.encodePacked(SEED, i, line, tokenId.toString())));
            output = string(abi.encodePacked(output, franks[rand % franks.length]));
        }

        return output;
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
        string[17] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getLine(tokenId, 1);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getLine(tokenId, 2);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getLine(tokenId, 3);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = getLine(tokenId, 4);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = getLine(tokenId, 5);

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = getLine(tokenId, 6);

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = getLine(tokenId, 7);

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = getLine(tokenId, 8);

        parts[16] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8])
        );
        output = string(
            abi.encodePacked(
                output,
                parts[9],
                parts[10],
                parts[11],
                parts[12],
                parts[13],
                parts[14],
                parts[15],
                parts[16]
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "frankfrank #',
                        tokenId.toString(),
                        '", "description": "frankfrankFRANKFRANKFRANK FRANKfrankFRANK frankfrankFRANKfrank frankFRANKfrank frankFRANK FRANKfrank FRANKfrankFRANK frankfrankfrank frankFRANKfrankFRANKfrankFRANK frankFRANK FRANKfrankfrank frankfrankfrankFRANK frank FRANKfrank FRANK frankfrankFRANK frankFRANKfrank frank FRANK FRANKFRANKFRANK FRANKFRANKfrank frank FRANK frankfrankfrankfrank frank frankFRANKfrank", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }

    function supportsInterface(bytes4 interfaceId) public pure override(ERC721, ERC2981) returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC721Metadata
            ERC2981.supportsInterface(interfaceId);
    }
}