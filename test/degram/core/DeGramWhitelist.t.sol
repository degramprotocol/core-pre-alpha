// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../../../src/contracts/degram/core/DeGramWhitelist.sol";  // Adjust the path according to your project structure

contract DeGramWhitelistTest is Test {
    DeGramWhitelist private deGramWhitelist;
    address private owner = address(this);
    address private newOwner = address(0x123);
    address private admin1 = address(0x456);
    address private user1 = address(0x789);
    address private user2 = address(0xABC);

    function setUp() public {
        deGramWhitelist = new DeGramWhitelistImplementation(); // DeGramWhitelist is an abstract contract, create a concrete implementation for testing
        deGramWhitelist.updateAdmin(admin1, true);
    }

    function testDirectWhitelist() public {
        vm.prank(admin1);
        deGramWhitelist.directWhitelist(user1, true);
        assertTrue(deGramWhitelist.whitelistStatus(user1));
    }

    function testRemoveFromWhitelist() public {
        vm.prank(admin1);
        deGramWhitelist.directWhitelist(user1, true);
        vm.prank(admin1);
        deGramWhitelist.directWhitelist(user1, false);
        assertFalse(deGramWhitelist.whitelistStatus(user1));
    }

    function testOnlyAdminCanDirectWhitelist() public {
        vm.prank(user1);
        vm.expectRevert("Only an admin can perform this action!");
        deGramWhitelist.directWhitelist(user2, true);
    }

    // function testReferWhitelist() public {
    //     vm.prank(admin1);
    //     deGramWhitelist.directWhitelist(user1, true);
    //     vm.prank(admin1);
    //     deGramWhitelist.updateCanRefer(true);
    //     vm.prank(user1);
    //     deGramWhitelist.referWhitelist(user2);
    //     assertTrue(deGramWhitelist.whitelistStatus(user2));
    //     assertEq(deGramWhitelist.whitelistReferrer(user2), user1);

    //     // Wait for cooldown to expire and refer again
    //     vm.warp(block.timestamp + deGramWhitelist.coolDownTime() + 1);
    //     vm.prank(user1);
    //     address user3 = address(0xDEF);
    //     deGramWhitelist.referWhitelist(user3);
    //     assertTrue(deGramWhitelist.whitelistStatus(user3));
    //     assertEq(deGramWhitelist.whitelistReferrer(user3), user1);
    // }

    // function testCannotReferDuringCooldown() public {
    //     vm.prank(admin1);
    //     deGramWhitelist.directWhitelist(user1, true);
    //     vm.prank(admin1);
    //     deGramWhitelist.updateCanRefer(true);
    //     vm.prank(user1);
    //     deGramWhitelist.referWhitelist(user2);
    //     vm.prank(user1);
    //     vm.expectRevert("Referrer is still on cooldown");
    //     deGramWhitelist.referWhitelist(user2);

    //     // Wait for cooldown to expire and refer again
    //     vm.warp(block.timestamp + deGramWhitelist.coolDownTime());
    //     vm.prank(user1);
    //     address user3 = address(0xDEF);
    //     deGramWhitelist.referWhitelist(user3);
    //     assertTrue(deGramWhitelist.whitelistStatus(user3));
    // }

    function testUpdateReferralStatus() public {
        vm.prank(admin1);
        deGramWhitelist.updateCanRefer(true);
        assertTrue(deGramWhitelist.getCanReferStatus());
        vm.prank(admin1);
        deGramWhitelist.updateCanRefer(false);
        assertFalse(deGramWhitelist.getCanReferStatus());
    }

    function testOnlyAdminCanUpdateReferralStatus() public {
        vm.prank(user1);
        vm.expectRevert("Only an admin can perform this action!");
        deGramWhitelist.updateCanRefer(true);
    }

    function testUpdateCooldown() public {
        vm.prank(admin1);
        deGramWhitelist.updateCoolDown(2000);
        assertEq(deGramWhitelist.coolDownTime(), 2000);
    }

    function testOnlyAdminCanUpdateCooldown() public {
        vm.prank(user1);
        vm.expectRevert("Only an admin can perform this action!");
        deGramWhitelist.updateCoolDown(2000);
    }

    function testCannotWhitelistZeroAddress() public {
        vm.prank(admin1);
        vm.expectRevert("Invalid address");
        deGramWhitelist.directWhitelist(address(0), true);
    }

    function testCannotUpdateToSameStatus() public {
        vm.prank(admin1);
        deGramWhitelist.directWhitelist(user1, true);
        vm.prank(admin1);
        vm.expectRevert("Whitelist status is already updated");
        deGramWhitelist.directWhitelist(user1, true);
    }

    function testCannotReferWhenReferralDisabled() public {
        vm.prank(admin1);
        deGramWhitelist.directWhitelist(user1, true);
        vm.prank(user1);
        vm.expectRevert("DeGram stopped referral whitelisting process. Users can only be directly whitelisted.");
        deGramWhitelist.referWhitelist(user2);
    }

    // function testGetReferrerTimestamp() public {
    //     vm.prank(admin1);
    //     deGramWhitelist.directWhitelist(user1, true);
    //     vm.prank(admin1);
    //     deGramWhitelist.updateCanRefer(true);
    //     vm.prank(user1);
    //     deGramWhitelist.referWhitelist(user2);
    //     assertGt(deGramWhitelist.getReferrerTimestamp(user1), 0);

    //     // Wait for cooldown to expire and refer again
    //     vm.warp(block.timestamp + deGramWhitelist.coolDownTime());
    //     vm.prank(user1);
    //     address user3 = address(0xDEF);
    //     deGramWhitelist.referWhitelist(user3);
    //     assertGt(deGramWhitelist.getReferrerTimestamp(user1), 0);
    // }
}

// Concrete implementation of DeGramWhitelist for testing
contract DeGramWhitelistImplementation is DeGramWhitelist {}