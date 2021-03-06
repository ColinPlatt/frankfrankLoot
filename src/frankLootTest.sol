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

    uint256 public pricePerFrank = 0.042069 ether;
    address public owner;

    //IFrank public immutable frank = IFrank(0x91680cF5F9071cafAE21B90ebf2c9CC9e480fB93);
    IFrank public frank;

    uint256 public SEED;

    string[] private franks = [
        "frank",
        "frank",
        "frank",
        "FRANK",
        "frank ", 
        "FRANK ",
        "frank",
        "frank",
        "frank",
        "FRANK",
        "frank ", 
        "FRANK ",
        "frank",
        "frank",
        "frank",
        "FRANK",
        "frank ", 
        "FRANK ",
        "frank",
        "frank",
        "frank",
        "FRANK",
        "frank ", 
        "FRANK ",
        unicode"f̶̝̊̒r̶̙̄͠a̵͍̺̖̾͊͝ǹ̸̘̖̄̀k̶̬̙̲͊͋",
        unicode"F̴̥̬̃͋̆R̵͋̿͒ͅÄ̴̡͈͜͠Ṇ̶͕͈̀K̵̹͚̏̂",
        unicode"F̶͕̾R̸̬͐A̶͇̒N̷̢̆K̶̮͗",
        unicode"f̵͎̦̠̻̮͍̝̍́́̎̐͋͊̂̾̈̀͊̑̚ŗ̸̱̺̹͖̱̫͉̺͎̆̏̅̕͜ą̴̡̡̫̞̻͎̲͚̯̗̭̬̺̼̒͂̓̊͝n̸̢̼̖̦̗̐̈́̂͌̽̆́̋̂͑͝ͅk̴̛̛̥̻͖͉͚͔̊̉̾̆̈̏̈́̈͜ ",
        unicode"F̵̰͎̣̩̮̰̗͈̥͍͔͖͕͆̆́̏̚͜͝Ȓ̷̞͔͚̦̽̂̂̒̚͝A̴̱̺͚͙͖̹̞̲̘͒͊͑̄͒̓͒̓̀͂̋̐͂̔͘N̵͈̟̺̼̮̯̟̩͗̆̇̾͐̈̓̾̔͋̑̈͆Ḱ̷̡̢͉̜̟͖̣̝̥̗̰̙̬̥̻̈̿̀̉̆̈̇͂̓́͠ "
    ];

    string[] private shakes = [
        '<animateTransform attributeName="transform" attributeType="XML" type="scale" from="1 1" to="0 1" dur="1s" repeatCount="indefinite"/>',
        '<animateTransform attributeName="transform" attributeType="XML" type="scale" from="1 1" to="2 2" dur="1s" repeatCount="indefinite"/>',
        '<animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0" to="-2" dur="0.1s" repeatCount="indefinite"/>',
        '<animateTransform attributeName="transform" attributeType="XML" type="translate" from="0 0" to="-5 4" dur="0.1s" repeatCount="indefinite"/>',
        '<animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 0 0" to="45 45 500" dur="2s" repeatCount="indefinite" />',
        '<animate attributeName="opacity" dur="0.25s" keyTimes="0;0.1;0.5;0.6;1" values="0;1;1;0;0" repeatCount="indefinite" />'
    ];

    /*
   
    */

    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _frank)
    ERC721("frankLoot", "FRANKLOOT") {
        frank = IFrank(_frank);
        _royaltyFee = 700;
        _royaltyRecipient = msg.sender;
        SEED = random(block.timestamp.toString());
        owner = msg.sender;
        testMint(100);
    }

    /*//////////////////////////////////////////////////////////////
                    FRANKLY OWNER-RESTRICTED FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    modifier requiresAuth() {
        require(owner == msg.sender, "FRANKLY_NOT_ALLOWED");
        _;
    }

    function setPrice(uint256 newPrice) requiresAuth public {
        pricePerFrank = newPrice;
    }

    function setRoyaltyRecipient(address recipient) requiresAuth public {
        _royaltyRecipient = recipient;
    }

    function setRoyaltyFee(uint256 fee) requiresAuth public {
        _royaltyFee = fee;
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

        if (greatness > 12) {
            return random(string(abi.encodePacked(_line.toString(), _tokenId.toString()))) % 7 + 1;
        } else {
            return 1;
        }

    }

    function getLine(uint256 tokenId, uint256 line) internal view returns (string memory) {
        uint256 franksThisLine = franksPerLine(tokenId, line);
        uint256 greatness = random(string(abi.encodePacked(SEED, tokenId.toString()))) % 21;

        string memory output;

        for(uint256 i = 0; i < franksThisLine; i++) {
            uint256 rand = random(string(abi.encodePacked(SEED, i, line, tokenId.toString())));
            if (greatness > 14) {
                output = string(abi.encodePacked(output, franks[rand % franks.length]));
            } else {
                output = string(abi.encodePacked(output, franks[rand % 24]));
            }
            
        }

        uint256 shakeRand = random(string(abi.encodePacked(SEED, line, tokenId.toString())));
        uint256 shakeGreatness = shakeRand % 21;
        if(shakeGreatness > 17) {
            output = string(abi.encodePacked(output, shakes[shakeRand % shakes.length]));
        }

        return output;
    }

    /*//////////////////////////////////////////////////////////////
                        FRANKLY PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function mintWithFrank(uint256 frankId) public {
        require(frankId >= 0 && frankId < 2000, "FRANKLY_INVALID");
        require(frank.ownerOf(frankId) == msg.sender, "FRANKLY_NOT_YOURS");
        _safeMint(msg.sender, frankId);
    }

    function mintWithFrank(uint256[] memory frankId) public {
        uint256 frankfranks = frankId.length;
        for (uint256 i = 0; i < frankfranks; i++) {
            require(frankId[i] >= 0 && frankId[i] < 2000, "FRANKLY_INVALID");
            require(frank.ownerOf(frankId[i]) == msg.sender, "FRANKLY_NOT_YOURS");
           _safeMint(msg.sender, frankId[i]);
        }
    }

    function franklessMint(uint256 frankId) public payable {
        require(msg.value >= pricePerFrank, "FRANKLY_TOO_CHEAP");
        require(frankId >= 2000 && frankId < 4000, "FRANKLY_INVALID");
        _safeMint(msg.sender, frankId);
    }

    function testMint(uint256 amount) internal {
        for (uint256 i = 0; i <amount; i++) {
            _safeMint(msg.sender, i);
        }
        
    }


    /*//////////////////////////////////////////////////////////////
                        FRANKLY VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[25] memory parts;
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

        parts[16] = '</text><text x="10" y="180" class="base">';

        parts[17] = getLine(tokenId, 9);

        parts[18] = '</text><text x="10" y="200" class="base">';

        parts[19] = getLine(tokenId, 10);

        parts[20] = '</text><text x="10" y="220" class="base">';

        parts[21] = getLine(tokenId, 11);

        parts[22] = '</text><text x="10" y="240" class="base">';

        parts[23] = getLine(tokenId, 12);

        parts[24] = "</text></svg>";

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

                output = string(
            abi.encodePacked(
                output,
                parts[17], 
                parts[18],
                parts[19],
                parts[20],
                parts[21],
                parts[22],
                parts[23],
                parts[24]
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