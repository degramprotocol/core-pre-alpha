/*
 SPDX-License-Identifier: MIT
*/
pragma solidity 0.8.20;

// Import the DeGramProfiles contract
import "./DeGramProfiles.sol";
// Import the ReentrancyGuard contract
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title DeGram Profile Details Contract
 * @dev This contract manages the detailed information associated with DeGram profiles.
 */
contract DeGramProfileDetails is ReentrancyGuard {

    /**
     * @dev Instance of the DeGramProfiles contract.
     */
    DeGramProfiles private immutable _deGramProfiles;

    /**
     * @dev Contract constructor. Initializes the DeGramProfiles contract address.
     * @param _deGramProfilesAddress The address of the DeGramProfiles contract.
     */

     constructor(address _deGramProfilesAddress) {
        _deGramProfiles = DeGramProfiles(_deGramProfilesAddress);
    }

    /**
     * @dev Struct to store detailed information about a profile.
     */
    struct ProfileDetails {
        string fullName;
        string bio;
        string profilePicture;
        int age;
        string avatar;
        string avatarId;
        uint256 joinedDate;
        string timezone;
        address pointer;
    }

    /**
     * @dev Mapping to store profile details for each address.
     */
    mapping(address => ProfileDetails) private _profileDetails;

    event ProfileUpdated(address indexed user, string field, string newValue);
    event ProfileCreated(address indexed user, string fullName);

    /**
     * @dev Function to update the profile details.
     * @param _fullName The full name of the profile owner.
     * @param _bio The biography or description of the profile owner.
     * @param _profilePicture The profile picture URL.
     * @param _age The age of the profile owner.
     * @param _avatar The avatar image URL.
     * @param _avatarId The ID associated with the avatar.
     * @param _timezone The timezone of the profile owner.
     * @param _pointer The address pointer to the additional profile details (Based on badges).
     */
     function updateProfileDetails(
        string memory _fullName,
        string memory _bio,
        string memory _profilePicture,
        int _age,
        string memory _avatar,
        string memory _avatarId,
        string memory _timezone,
        address _pointer
    ) public nonReentrant {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        uint256 fullnamelen = StringUtils.strlen(_fullName);
        uint256 biolen = StringUtils.strlen(_bio);
        require(fullnamelen > 0 && fullnamelen <= 60, "Full name must be between 1 and 60 characters");
        require(biolen > 0 && biolen <= 350, "Bio length must be between 1 and 350 characters");
        require(_age < int(block.timestamp - 567648000), "Age Limit is 18 Years!");

        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.fullName = _fullName;
        profile.bio = _bio;
        profile.profilePicture = _profilePicture;
        profile.age = _age;
        profile.avatar = _avatar;
        profile.avatarId = _avatarId;
        profile.timezone = _timezone;
        profile.pointer = _pointer;
        if (profile.joinedDate == 0) {
            profile.joinedDate = block.timestamp;
            emit ProfileCreated(msg.sender, _fullName);
        }

        emit ProfileUpdated(msg.sender, "fullName", _fullName);
        emit ProfileUpdated(msg.sender, "bio", _bio);
        emit ProfileUpdated(msg.sender, "profilePicture", _profilePicture);
        emit ProfileUpdated(msg.sender, "age", Strings.toString(uint256(_age)));
        emit ProfileUpdated(msg.sender, "avatar", _avatar);
        emit ProfileUpdated(msg.sender, "avatarId", _avatarId);
        emit ProfileUpdated(msg.sender, "timezone", _timezone);
        emit ProfileUpdated(msg.sender, "pointer", Strings.toHexString(uint160(_pointer), 20));
    }

    /**
     * @dev Function to retrieve the profile details for a given address.
     * @param _address The address of the profile owner.
     * @return The profile details for the given address.
     */
    function profileDetails(address _address) public view returns (ProfileDetails memory) {
        return _profileDetails[_address];
    }

    /**
     * @dev Function to update the full name of a profile.
     * @param _fullName The new full name to be set.
     */
    function updateFullName(string memory _fullName) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        uint256 fullnamelen = StringUtils.strlen(_fullName);
        require(fullnamelen > 0 && fullnamelen <= 60, "Full name must be between 1 and 60 characters");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.fullName = _fullName;
        emit ProfileUpdated(msg.sender, "fullName", _fullName);
    }

    /**
     * @dev Function to update the bio of a profile.
     * @param _bio The new biography or description to be set.
     */
    function updateBio(string memory _bio) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        uint256 biolen = StringUtils.strlen(_bio);
        require(biolen > 0 && biolen <= 350, "Bio length must be between 1 and 350 characters");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.bio = _bio;
        emit ProfileUpdated(msg.sender, "bio", _bio);
    }

    /**
     * @dev Function to update the profile picture of a profile.
     * @param _profilePicture The new profile picture URL to be set.
     */
    function updateProfilePicture(string memory _profilePicture) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.profilePicture = _profilePicture;
        emit ProfileUpdated(msg.sender, "profilePicture", _profilePicture);
    }

    /**
     * @dev Function to update the age of a profile owner.
     * @param _age The new age to be set.
     */
    function updateAge(int _age) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        require(_age < int(block.timestamp - 567648000), "Age Limit is 18 Years!");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.age = _age;
        emit ProfileUpdated(msg.sender, "age", Strings.toString(uint256(_age)));
    }

    /**
     * @dev Function to update the avatar and its ID of a profile.
     * @param _avatar The new avatar image URL to be set.
     * @param _avatarId The new avatar ID to be set.
     */
    function updateAvatar(string memory _avatar, string memory _avatarId) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.avatar = _avatar;
        profile.avatarId = _avatarId;
        emit ProfileUpdated(msg.sender, "avatar", _avatar);
        emit ProfileUpdated(msg.sender, "avatarId", _avatarId);
    }
    
    /**
     * @dev Function to update the timezone of a profile owner.
     * @param _timezone The new timezone to be set.
     */
    function updateTimezone(string memory _timezone) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.timezone = _timezone;
        emit ProfileUpdated(msg.sender, "timezone", _timezone);
    }

    /**
     * @dev Function to update the address pointer of a profile owner.
     * @param _pointer The new address pointer to be set.
     */
    function updatePointer(address _pointer) public {
        require(_deGramProfiles.addressClaimed(msg.sender), "User should have an deGram Profile");
        ProfileDetails storage profile = _profileDetails[msg.sender];
        profile.pointer = _pointer;
        emit ProfileUpdated(msg.sender, "pointer", Strings.toHexString(uint160(_pointer), 20));
    }
}