// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../../../src/contracts/degram/core/DeGramProfiles.sol";  // Adjust the path according to your project structure

contract DeGramProfilesTest is Test {
    DeGramProfiles private deGramProfiles;
    address private owner = address(this);
    address private admin1 = address(0x456);
    address private user1 = address(0x789);
    address private user2 = address(0xABC);
    address private user3 = address(0xDEF);

    function setUp() public {
        deGramProfiles = new DeGramProfiles();
        deGramProfiles.updateAdmin(admin1, true);
    }

    function testRegisterProfile() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");
        assertEq(deGramProfiles.profiles("user1name"), user1);
        assertTrue(deGramProfiles.addressClaimed(user1));
        assertEq(deGramProfiles.getNameWithAddress(user1), "user1name");
    }

    function testCannotRegisterProfileWithInvalidName() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        vm.expectRevert("Username must be at least 3 characters long and less than 20 characters");
        deGramProfiles.register("us");

        vm.prank(user1);
        vm.expectRevert("Username must be at least 3 characters long and less than 20 characters");
        deGramProfiles.register("thisnameiswaytoolongforthevalidationcheck");

        vm.prank(user1);
        vm.expectRevert("Name must contain only small letters and numbers");
        deGramProfiles.register("InvalidName!");
    }

    function testCannotRegisterAlreadyClaimedName() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");

        vm.prank(admin1);
        deGramProfiles.directWhitelist(user2, true);
        vm.prank(user2);
        vm.expectRevert("Name already claimed");
        deGramProfiles.register("user1name");
    }

    function testCannotRegisterMultipleProfiles() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");

        vm.prank(user1);
        vm.expectRevert("User has already claimed a profile");
        deGramProfiles.register("anothername");
    }

    // function testReferWhitelist() public {
    //     vm.prank(admin1);
    //     deGramProfiles.directWhitelist(user1, true);
    //     vm.prank(user1);
    //     deGramProfiles.register("user1name");

    //     vm.prank(admin1);
    //     deGramProfiles.updateCanRefer(true);
    //     vm.prank(user1);
    //     deGramProfiles.referWhitelist(user2);

    //     assertTrue(deGramProfiles.whitelistStatus(user2));
    //     assertEq(deGramProfiles.whitelistReferrer(user2), user1);
    // }

    function testCannotReferWithoutProfile() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(admin1);
        deGramProfiles.updateCanRefer(true);

        vm.prank(user1);
        vm.expectRevert("User should have an deGram Profile");
        deGramProfiles.referWhitelist(user2);
    }

    function testCounterIncrement() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");

        assertEq(deGramProfiles.counter(), 1);

        vm.prank(admin1);
        deGramProfiles.directWhitelist(user2, true);
        vm.prank(user2);
        deGramProfiles.register("user2name");

        assertEq(deGramProfiles.counter(), 2);
    }

    function testPreventTransfers() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");

        vm.prank(user1);
        vm.expectRevert("Transfers are not allowed");
        deGramProfiles.transferFrom(user1, user2, 0);
    }

    function testPreventApprovals() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");

        vm.prank(user1);
        vm.expectRevert("Approvals are not allowed");
        deGramProfiles.approve(user2, 0);

        vm.prank(user1);
        vm.expectRevert("Approvals are not allowed");
        deGramProfiles.setApprovalForAll(user2, true);
    }

    function testUpdateReferralStatus() public {
        vm.prank(admin1);
        deGramProfiles.updateCanRefer(true);
        assertTrue(deGramProfiles.getCanReferStatus());

        vm.prank(admin1);
        deGramProfiles.updateCanRefer(false);
        assertFalse(deGramProfiles.getCanReferStatus());
    }

    function testOnlyAdminCanUpdateReferralStatus() public {
        vm.prank(user1);
        vm.expectRevert("Only an admin can perform this action!");
        deGramProfiles.updateCanRefer(true);
    }

    function testUpdateCooldown() public {
        vm.prank(admin1);
        deGramProfiles.updateCoolDown(2000);
        assertEq(deGramProfiles.coolDownTime(), 2000);
    }

    function testOnlyAdminCanUpdateCooldown() public {
        vm.prank(user1);
        vm.expectRevert("Only an admin can perform this action!");
        deGramProfiles.updateCoolDown(2000);
    }

    function testCannotWhitelistZeroAddress() public {
        vm.prank(admin1);
        vm.expectRevert("Invalid address");
        deGramProfiles.directWhitelist(address(0), true);
    }

    function testCannotUpdateToSameStatus() public {
        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);

        vm.prank(admin1);
        vm.expectRevert("Whitelist status is already updated");
        deGramProfiles.directWhitelist(user1, true);
    }

    // function testCannotReferWhenReferralDisabled() public {
    //     vm.prank(admin1);
    //     deGramProfiles.directWhitelist(user1, true);

    //     vm.prank(user1);
    //     vm.expectRevert("DeGram stopped referral whitelisting process. Users can only be directly whitelisted.");
    //     deGramProfiles.referWhitelist(user2);
    // }

    // function testGetReferrerTimestamp() public {
    //     vm.prank(admin1);
    //     deGramProfiles.directWhitelist(user1, true);
    //     vm.prank(admin1);
    //     deGramProfiles.updateCanRefer(true);
    //     vm.prank(user1);
    //     deGramProfiles.referWhitelist(user2);
    //     assertGt(deGramProfiles.getReferrerTimestamp(user1), 0);

    //     // Wait for cooldown to expire and refer again
    //     vm.warp(block.timestamp + deGramProfiles.coolDownTime());
    //     vm.prank(user1);
    //     deGramProfiles.referWhitelist(user3);
    //     assertGt(deGramProfiles.getReferrerTimestamp(user1), 0);
    // }
}
