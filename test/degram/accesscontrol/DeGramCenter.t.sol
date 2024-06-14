// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../../src/contracts/degram/accesscontrol/DeGramCenter.sol";  // Adjust the path according to your project structure

contract DeGramCenterTest is Test {
    DeGramCenter private deGramCenter;
    address private owner = address(this);
    address private newOwner = address(0x123);
    address private admin1 = address(0x456);
    address private admin2 = address(0x789);

    function setUp() public {
        deGramCenter = new DeGramCenterImplementation(); // DeGramCenter is an abstract contract, create a concrete implementation for testing
    }

    function testOwnerIsSetCorrectly() public view {
        assertEq(deGramCenter.owner(), owner);
    }

    function testUpdateAdmin() public {
        deGramCenter.updateAdmin(admin1, true);
        assertTrue(deGramCenter.admin(admin1));
    }

    function testRemoveAdmin() public {
        deGramCenter.updateAdmin(admin1, true);
        deGramCenter.updateAdmin(admin1, false);
        assertFalse(deGramCenter.admin(admin1));
    }

    function testOnlyOwnerCanUpdateAdmin() public {
        vm.prank(admin1);
        vm.expectRevert("Only the owner can perform this action!");
        deGramCenter.updateAdmin(admin2, true);
    }

    function testTransferOwnership() public {
        deGramCenter.transferOwnership(newOwner);
        assertEq(deGramCenter.owner(), newOwner);
    }

    function testOnlyOwnerCanTransferOwnership() public {
        vm.prank(admin1);
        vm.expectRevert("Only the owner can perform this action!");
        deGramCenter.transferOwnership(admin2);
    }

    function testTransferOwnershipToZeroAddress() public {
        vm.expectRevert("New owner cannot be the zero address");
        deGramCenter.transferOwnership(address(0));
    }
}

// Concrete implementation of DeGramCenter for testing
contract DeGramCenterImplementation is DeGramCenter {}