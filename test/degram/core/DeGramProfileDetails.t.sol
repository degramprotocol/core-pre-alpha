// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../../../src/contracts/degram/core/DeGramProfiles.sol";  // Adjust the path according to your project structure
import "../../../../src/contracts/degram/core/DeGramProfileDetails.sol";  // Adjust the path according to your project structure
import "@openzeppelin/contracts/utils/Strings.sol";
import "../../../../src/contracts/degram/libraries/StringUtils.sol";  // Assume this is a utility contract you have for string operations

contract DeGramProfileDetailsTest is Test {
    DeGramProfiles private deGramProfiles;
    DeGramProfileDetails private deGramProfileDetails;
    address private owner = address(this);
    address private admin1 = address(0x456);
    address private user1 = address(0x789);

    function setUp() public {
        deGramProfiles = new DeGramProfiles();
        deGramProfiles.updateAdmin(admin1, true);
        deGramProfileDetails = new DeGramProfileDetails(address(deGramProfiles));

        vm.prank(admin1);
        deGramProfiles.directWhitelist(user1, true);
        vm.prank(user1);
        deGramProfiles.register("user1name");
    }

    function testUpdateProfileDetails() public {
        vm.prank(user1);
        deGramProfileDetails.updateProfileDetails(
            "Full Name",
            "This is a bio.",
            "http://example.com/profile.jpg",
            938440798,
            "http://example.com/avatar.jpg",
            "avatar123",
            "UTC+0",
            address(0xABC)
        );

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.fullName, "Full Name");
        assertEq(details.bio, "This is a bio.");
        assertEq(details.profilePicture, "http://example.com/profile.jpg");
        assertEq(details.age, 938440798); // Ensure this is correctly displayed
        assertEq(details.avatar, "http://example.com/avatar.jpg");
        assertEq(details.avatarId, "avatar123");
        assertEq(details.timezone, "UTC+0");
        assertEq(details.pointer, address(0xABC));
    }

    function testUpdateFullName() public {
        vm.prank(user1);
        deGramProfileDetails.updateFullName("New Full Name");

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.fullName, "New Full Name");
    }

    function testUpdateBio() public {
        vm.prank(user1);
        deGramProfileDetails.updateBio("This is a new bio.");

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.bio, "This is a new bio.");
    }

    function testUpdateProfilePicture() public {
        vm.prank(user1);
        deGramProfileDetails.updateProfilePicture("http://example.com/newprofile.jpg");

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.profilePicture, "http://example.com/newprofile.jpg");
    }

    function testUpdateAge() public {
        vm.prank(user1);
        deGramProfileDetails.updateAge(938440791);

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.age, 938440791);
    }

    function testUpdateAvatar() public {
        vm.prank(user1);
        deGramProfileDetails.updateAvatar("http://example.com/newavatar.jpg", "avatar456");

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.avatar, "http://example.com/newavatar.jpg");
        assertEq(details.avatarId, "avatar456");
    }

    function testUpdateTimezone() public {
        vm.prank(user1);
        deGramProfileDetails.updateTimezone("UTC+1");

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.timezone, "UTC+1");
    }

    function testUpdatePointer() public {
        vm.prank(user1);
        deGramProfileDetails.updatePointer(address(0xDEF));

        DeGramProfileDetails.ProfileDetails memory details = deGramProfileDetails.profileDetails(user1);
        assertEq(details.pointer, address(0xDEF));
    }

    function testCannotUpdateProfileWithoutProfile() public {
        address nonProfileUser = address(0x123);
        vm.prank(nonProfileUser);
        vm.expectRevert("User should have an deGram Profile");
        deGramProfileDetails.updateFullName("Name");
    }

    function testCannotUpdateProfileWithInvalidFullName() public {
        vm.prank(user1);
        vm.expectRevert("Full name must be between 1 and 60 characters");
        deGramProfileDetails.updateFullName("");

        vm.prank(user1);
        vm.expectRevert("Full name must be between 1 and 60 characters");
        deGramProfileDetails.updateFullName("This full name is way too long for the validation check to pass");
    }

    function testCannotUpdateProfileWithInvalidBio() public {
        vm.prank(user1);
        vm.expectRevert("Bio length must be between 1 and 350 characters");
        deGramProfileDetails.updateBio("");

        string memory longBio = new string(351);
        for (uint i = 0; i < 351; i++) {
            longBio = string(abi.encodePacked(longBio, "a"));
        }

        vm.prank(user1);
        vm.expectRevert("Bio length must be between 1 and 350 characters");
        deGramProfileDetails.updateBio(longBio);
    }

    function testCannotUpdateProfileWithInvalidAge() public {
        vm.prank(user1);
        vm.expectRevert("Age Limit is 18 Years!");
        deGramProfileDetails.updateAge(938440798);
    }
}
