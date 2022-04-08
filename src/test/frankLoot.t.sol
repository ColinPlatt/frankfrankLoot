// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "../frankLoot.sol";
import "./dummyERC721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";

contract FrankLootTest is DSTest, ERC721TokenReceiver {
    
    DummyERC721 public frank;
    FrankLoot public frankLoot;

    address public operator;
    address public from;
    uint256 public id;
    bytes public data;

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _id,
        bytes calldata _data
    ) public virtual override returns (bytes4) {
        operator = _operator;
        from = _from;
        id = _id;
        data = _data;

        return ERC721TokenReceiver.onERC721Received.selector;
    }

    function setUp() public {
        frank = new DummyERC721("frank", "FRANK");
        frankLoot = new FrankLoot(address(frank));
    }

    function testInvariantMetaData() public {
        assertEq(frank.name(), "frank");
        assertEq(frank.symbol(), "FRANK");
        assertEq(frankLoot.name(), "frankLoot");
        assertEq(frankLoot.symbol(), "FRANKLOOT");
    }

    function mintFranks() public {
        for (uint256 i = 0; i<10; i++) {
            frank.mint(i);
        }
    }

    function testMintFrank() public {
        mintFranks();
        
        assertEq(frank.ownerOf(0), address(this));
        assertEq(frank.balanceOf(address(this)), 10);

        frankLoot.mintWithFrank(0);

        assertEq(frankLoot.ownerOf(0), address(this));
        assertEq(frankLoot.balanceOf(address(this)), 1);

        uint256[] memory bulkList = new uint256[](9);
        
        for(uint256 i = 0; i<9; i++) {
            bulkList[i] = i+1;
        }

        frankLoot.mintWithFrank(bulkList);

        assertEq(frankLoot.balanceOf(address(this)), 10);
    }

    function testFrankMetaData() public {
        mintFranks();
        
        assertEq(frank.ownerOf(0), address(this));
        assertEq(frank.balanceOf(address(this)), 10);

        uint256[] memory bulkList = new uint256[](10);
        
        for(uint256 i = 0; i<10; i++) {
            bulkList[i] = i;
        }

        frankLoot.mintWithFrank(bulkList);

        for(uint256 i = 0; i<10; i++) {
            emit log_string(frankLoot.tokenURI(i));
        }
    }

    
}
