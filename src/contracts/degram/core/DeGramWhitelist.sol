// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Import the DeGramCenter contract
import "../accesscontrol/DeGramCenter.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title DeGramWhitelist Contract
 * @dev This contract extends DeGramCenter and manages the whitelist functionality.
 */
abstract contract DeGramWhitelist is DeGramCenter, ReentrancyGuard {
    
    /**
     * @dev Struct to store whitelist data for each address
     */
    struct _WhitelistData {
        bool _status;          
        address _referrer;    
    }

    /**
     * @dev Mapping to store whitelist data for each address
     */
    mapping(address => _WhitelistData) private _whitelistStatus;

    /**
     * @dev Cooldown period for referrals in minutes
     */
    uint private _referralCooldown = 1440 minutes;

    /**
     * @dev Mapping to store the timestamp of the last referral for each referrer
     */
    mapping(address => uint) private _referrerTimeStamp;

    /**
     * @dev Flag to control whether referrals are allowed
     */
    bool private canRefer;

    /**
     * @dev Event to log direct whitelisting of an address
     */
    event DirectlyWhitelisted(address indexed user, bool newStatus);

    /**
     * @dev Event to log whitelisting through a referral
     */
    event ReferredWhitelisted(address indexed user, address indexed referrer);

    /**
     * @dev Event to log updates to referral cooldown period
     */
    event CooldownUpdated(uint newCooldown);

    /**
     * @dev Event to log updates to referral status
     */
    event ReferralStatusUpdated(bool newStatus);

    /**
     * @dev Modifier to restrict function calls to whitelisted addresses only
     */
    modifier onlyWhitelisted() {
        require(_whitelistStatus[msg.sender]._status == true, "Only Whitelisted user can perform this action!");
        _;
    }

    /**
     * @dev Function to directly whitelist an address
     * @param _address The address to whitelist
     * @param _status The new whitelist status
     */
    function directWhitelist(address _address, bool _status) public onlyAdmin {
        require(_address != address(0), "Invalid address");
        require(_whitelistStatus[_address]._status != _status, "Whitelist status is already updated");
        _whitelistStatus[_address]._status = _status;
        emit DirectlyWhitelisted(_address, _status);
    }

    /**
     * @dev Function to whitelist an address through a referral
     * @param _address The address to whitelist
     */
    function referWhitelist(address _address) public virtual onlyWhitelisted nonReentrant{
        require(canRefer, "DeGram stopped referral whitelisting process. Users can only be directly whitelisted.");
        require(_address != address(0), "Invalid address");
        require(!_whitelistStatus[_address]._status, "This address is already whitelisted");
        require(block.timestamp >= _referrerTimeStamp[msg.sender] + _referralCooldown, "Referrer is still on cooldown");
        _referrerTimeStamp[_address] = block.timestamp + _referralCooldown;
        _referrerTimeStamp[msg.sender] = block.timestamp;
        _whitelistStatus[_address]._status = true;
        _whitelistStatus[_address]._referrer = msg.sender;
        emit ReferredWhitelisted(_address, msg.sender);
    }

    /**
     * @dev Function to update the user can refer or not
     * @param _status The new referral status
     */
    function updateCanRefer(bool _status) public onlyAdmin {
        require(canRefer != _status, "Referral whitelisting status already updated");
        canRefer = _status;
        emit ReferralStatusUpdated(_status);
    }

    /**
     * @dev Function to retrieve the referral status
     * @return The current referral status
     */
    function getCanReferStatus() public view virtual returns (bool) {
        return canRefer;
    }

    /**
     * @dev Function to update the referral cooldown period
     * @param _cooldownTime The new cooldown time in minutes
     */
    function updateCoolDown(uint _cooldownTime) public onlyAdmin {
        require(_cooldownTime > 0, "Cooldown time must be greater than zero");
        _referralCooldown = _cooldownTime;
        emit CooldownUpdated(_cooldownTime);
    }

    /**
     * @dev Function to retrieve the whitelist status of an address
     * @param _address The address to check
     * @return The whitelist status
     */
    function whitelistStatus(address _address) public view virtual returns (bool) {
        return _whitelistStatus[_address]._status;
    }

    /**
     * @dev Function to retrieve the referrer of a whitelisted address
     * @param _address The whitelisted address
     * @return The referrer address
     */
    function whitelistReferrer(address _address) public view virtual returns (address) {
        return _whitelistStatus[_address]._referrer;
    }

    /**
     * @dev Function to retrieve the referral cooldown time
     * @return The cooldown time in minutes
     */
    function coolDownTime() public view virtual returns (uint) {
        return _referralCooldown;
    }

    /**
     * @dev Function to retrieve the referrer timestamp
     * @return The referrer last referral timestamp.
     */
    function getReferrerTimestamp(address _address) public view returns (uint) {
        return _referrerTimeStamp[_address];
    }
}
