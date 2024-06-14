// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title DeGramCenter Contract
 * @dev This contract defines the administrative functions and ownership for DeGram Center.
 */
abstract contract DeGramCenter {
    
    /**
     * @dev The owner of the deGram contracts
     */
    address private _owner;

    /**
     * @dev Mapping to store deGram admin addresses and their status
     */
    mapping(address => bool) private _admins;

    /**
     * @dev Event to log updates to admin status
     */
    event AdminStatusUpdated(address indexed adminAddress, bool status);

    /**
     * @dev Event to log ownership transfer
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Modifier to restrict function calls to the deGram owner only
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can perform this action!");
        _; 
    }

    /**
     * @dev Modifier to restrict function calls to deGram admins only
     */
    modifier onlyAdmin() {
        require(_admins[msg.sender], "Only an admin can perform this action!");
        _; 
    }

    /**
     * @dev Function to update the admin status of an address
     * @param _address The address of the admin to update
     * @param _status The new status of the admin (true for admin, false otherwise)
     */
    function updateAdmin(address _address, bool _status) public onlyOwner {
        _admins[_address] = _status;
        emit AdminStatusUpdated(_address, _status);
    }

    /**
     * @dev Function to retrieve the owner address
     * @return The address of the owner
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Function to check if an address is an admin
     * @param _address The address to check
     * @return True if the address is an admin, false otherwise
     */
    function admin(address _address) public view returns (bool) {
        return _admins[_address];
    }

    /**
     * @dev Contract constructor
     * Sets the initial owner as the deploying address
     */
    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Function to transfer ownership to a new address
     * @param newOwner The address of the new owner
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
