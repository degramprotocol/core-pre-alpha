// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../../../src/contracts/degram/core/DeGramProfiles.sol";  // Adjust the path according to your project structure
import "../../../../src/contracts/degram/core/DeGramBadges.sol";  // Adjust the path according to your project structure

contract DeGramBadgesTest is Test {
    DeGramProfiles private deGramProfiles;
    DeGramBadges private deGramBadges;
    address private owner = address(this);
    address private admin1 = address(0x456);
    address private user1 = address(0x789);

    function setUp() public {
        deGramProfiles = new DeGramProfiles();
        deGramProfiles.updateAdmin(admin1, true);
        deGramBadges = new DeGramBadges(address(deGramProfiles));

        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");
    }

    function testAddOrUpdateBadge() public {
        vm.prank(admin1);
        deGramBadges.addOrUpdateBadge(user1, DeGramBadges._BadgeType.Human, "Verified Human");

        DeGramBadges._Badge memory badge = deGramBadges.getBadge(user1);
        assertEq(uint(badge._badgeType), uint(DeGramBadges._BadgeType.Human));
        assertEq(badge._badgeData, "Verified Human");
    }

    function testRemoveBadge() public {
        vm.prank(admin1);
        deGramBadges.addOrUpdateBadge(user1, DeGramBadges._BadgeType.Human, "Verified Human");

        vm.prank(admin1);
        deGramBadges.removeBadge(user1);

        DeGramBadges._Badge memory badge = deGramBadges.getBadge(user1);
        assertEq(uint(badge._badgeType), uint(DeGramBadges._BadgeType.None));
        assertEq(badge._badgeData, "");
    }

    function testAddOrUpdateBadgeOnlyAdmin() public {
        vm.prank(user1);
        vm.expectRevert("Only deGram Admin can perform this action!");
        deGramBadges.addOrUpdateBadge(user1, DeGramBadges._BadgeType.Human, "Verified Human");
    }

    function testRemoveBadgeOnlyAdmin() public {
        vm.prank(admin1);
        deGramBadges.addOrUpdateBadge(user1, DeGramBadges._BadgeType.Human, "Verified Human");

        vm.prank(user1);
        vm.expectRevert("Only deGram Admin can perform this action!");
        deGramBadges.removeBadge(user1);
    }

    function testAddOrUpdateBadgeProfileExists() public {
        address nonProfileUser = address(0x123);

        vm.prank(admin1);
        vm.expectRevert("Profile does not exist");
        deGramBadges.addOrUpdateBadge(nonProfileUser, DeGramBadges._BadgeType.Human, "Verified Human");
    }

    function testRemoveBadgeProfileExists() public {
        address nonProfileUser = address(0x123);

        vm.prank(admin1);
        vm.expectRevert("Profile does not exist");
        deGramBadges.removeBadge(nonProfileUser);
    }
}
