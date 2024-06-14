/*
 SPDX-License-Identifier: MIT
*/
pragma solidity 0.8.20;

// Import the DeGramProfiles contract
import "./DeGramProfiles.sol";

/**
 * @title DeGram Badges Contract
 * @dev This contract manages the badges associated with DeGram profiles.  
 */
contract DeGramBadges {

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
     * @dev Enum representing different types of badges.
     */
    enum _BadgeType {
        None,
        Human,
        Government,
        Organization,
        Star,
        Whale,
        Bot,
        Pirate
    }

    /**
     * @dev Struct to store badge information.
     */
    struct _Badge {
        _BadgeType _badgeType;
        string _badgeData;
    }

    /**
     * @dev Mapping to store badges for each profile address.
     */
    mapping(address => _Badge) private _badges;

    /**
     * @dev Event to log the addition of a badge to a profile.
     */
    event BadgeAdded(address indexed profileAddress, _BadgeType badgeType, string badgeData);

    /**
     * @dev Event to log the removal of a badge from a profile.
     */
    event BadgeRemoved(address indexed profileAddress);

    /**
     * @dev Modifier to restrict access to only admin.
     */
    modifier onlyAdmin() {
        require(_deGramProfiles.admin(msg.sender), "Only deGram Admin can perform this action!");
        _;
    }

    /**
     * @dev Function to add or update a badge to a profile.
     * @param profileAddress The address of the profile.
     * @param badgeType The type of badge to be added.
     * @param badgeData Additional data associated with the badge.
     */
    function addOrUpdateBadge(address profileAddress, _BadgeType badgeType, string calldata badgeData) external onlyAdmin {
        require(_deGramProfiles.addressClaimed(profileAddress), "Profile does not exist");
        _badges[profileAddress] = _Badge(badgeType, badgeData);
        emit BadgeAdded(profileAddress, badgeType, badgeData);
    }

    /**
     * @dev Function to remove a badge from a profile.
     * @param profileAddress The address of the profile.
     */
    function removeBadge(address profileAddress) external onlyAdmin {
        require(_deGramProfiles.addressClaimed(profileAddress), "Profile does not exist");
        delete _badges[profileAddress];
        emit BadgeRemoved(profileAddress);
    }

    /**
     * @dev Function to retrieve the badge information for a profile.
     * @param profileAddress The address of the profile.
     * @return The badge information for the profile.
     */
    function getBadge(address profileAddress) public view returns (_Badge memory) {
        return _badges[profileAddress];
    }
}
