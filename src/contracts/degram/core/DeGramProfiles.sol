/*
 SPDX-License-Identifier: MIT
*/
pragma solidity 0.8.20;

// Import necessary OpenZeppelin and custom library contracts and deGramWhitelist contract
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import {StringUtils} from "../libraries/StringUtils.sol";
import {Base64} from "../libraries/Base64.sol";
import "./DeGramWhitelist.sol";

/**
 * @title DeGramProfiles Contract
 * @dev This contract manages the creation and ownership of DeGram profiles.                                                                
 */
contract DeGramProfiles is ERC721URIStorage, DeGramWhitelist{
    
    /**
     * @dev Contract constructor. Initializes the ERC-721 token name and symbol.
     */
    constructor()
        ERC721("deGram Profiles", "DGP")
    {
        
    }

    /**
     * @dev Counter to keep track of the number of profiles created.
     */
    uint256 private _counter;

    /**
     * @dev SVG prefix for the deGram profile token.
     */
    string constant svgPrefix = '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="600" fill="none"><path d="M0 20C0 8.954 8.954 0 20 0h360c11.046 0 20 8.954 20 20v560c0 11.046-8.954 20-20 20H20c-11.046 0-20-8.954-20-20V20z" fill="#1e1e1e"/><g clip-path="url(#A)"><path d="M200 300c20.681 0 37.5-16.819 37.5-37.5S220.681 225 200 225s-37.5 16.819-37.5 37.5S179.319 300 200 300zm0-62.5c13.787 0 25 11.212 25 25s-11.213 25-25 25-25-11.212-25-25 11.212-25 25-25zm62.1 130.562c.381 3.432-1.9 6.938-6.225 6.938a6.25 6.25 0 0 1-6.206-5.562C246.869 344.106 225.512 325 200 325s-46.869 19.106-49.669 44.438c-.381 3.431-3.494 5.918-6.9 5.524a6.25 6.25 0 0 1-5.525-6.9c3.506-31.675 30.206-55.562 62.1-55.562s58.588 23.887 62.094 55.562zm-25.35-.556a6.25 6.25 0 0 1-4.881 7.369 6.14 6.14 0 0 1-1.25.125 6.25 6.25 0 0 1-6.119-5.006C222.15 358.406 211.844 350 200.006 350s-22.144 8.406-24.494 19.994a6.23 6.23 0 0 1-7.368 4.881c-3.382-.688-5.569-3.987-4.882-7.369 3.532-17.387 18.988-30.006 36.744-30.006s33.213 12.619 36.744 30.006z" fill="#fff"/></g><g clip-path="url(#c)" style="fill: rgb(0, 0, 0);"><defs><clipPath id="c" class="svg-def"><rect width="118" height="30" fill="#fff" transform="translate(141 22)"/></clipPath></defs><path d="M151.376 22.652h-7.782a1.95 1.95 0 0 0-1.946 1.954v8.074a1.95 1.95 0 0 0 1.946 1.955h7.782a1.95 1.95 0 0 0 1.945-1.955v-8.074a1.95 1.95 0 0 0-1.945-1.954Z" style="fill: rgb(255, 255, 255);" class="fills"/><g class="strokes"><path d="M151.376 22.652h-7.782a1.95 1.95 0 0 0-1.946 1.954v8.074a1.95 1.95 0 0 0 1.946 1.955h7.782a1.95 1.95 0 0 0 1.945-1.955v-8.074a1.95 1.95 0 0 0-1.945-1.954Z" style="fill: none; stroke-width: 1.5; stroke: rgb(255, 255, 255); stroke-opacity: 1;" class="stroke-shape"/></g><path d="m164.396 25.942-2.655-2.732a1.826 1.826 0 0 0-2.63 0 1.896 1.896 0 0 0-.537 1.331 1.918 1.918 0 0 0 .537 1.33l2.678 2.752-2.657 2.734a1.917 1.917 0 0 0-.06 2.719 1.83 1.83 0 0 0 2.099.381 1.85 1.85 0 0 0 .587-.443l2.638-2.71 2.646 2.722c.346.356.819.558 1.314.558.496 0 .969-.202 1.315-.558.346-.356.537-.834.537-1.33 0-.497-.191-.975-.537-1.331l-2.668-2.742 2.668-2.747.015-.015.013-.015a1.916 1.916 0 0 0-.081-2.572 1.828 1.828 0 0 0-2.542-.083l-.015.014-.015.015-2.65 2.722Z" style="fill: rgb(255, 255, 255);" class="fills"/><g class="strokes"><path d="m164.396 25.942-2.655-2.732a1.826 1.826 0 0 0-2.63 0 1.896 1.896 0 0 0-.537 1.331 1.918 1.918 0 0 0 .537 1.33l2.678 2.752-2.657 2.734a1.917 1.917 0 0 0-.06 2.719 1.83 1.83 0 0 0 2.099.381 1.85 1.85 0 0 0 .587-.443l2.638-2.71 2.646 2.722c.346.356.819.558 1.314.558.496 0 .969-.202 1.315-.558.346-.356.537-.834.537-1.33 0-.497-.191-.975-.537-1.331l-2.668-2.742 2.668-2.747.015-.015.013-.015a1.916 1.916 0 0 0-.081-2.572 1.828 1.828 0 0 0-2.542-.083l-.015.014-.015.015-2.65 2.722Z" style="fill: none; stroke-width: 1.5; stroke: rgb(255, 255, 255); stroke-opacity: 1;" class="stroke-shape"/></g><path d="M170.208 45.23c0-3.239-2.613-5.865-5.836-5.865-3.224 0-5.837 2.626-5.837 5.865v.254c0 3.239 2.613 5.864 5.837 5.864 3.223 0 5.836-2.625 5.836-5.864v-.254Z" style="fill: rgb(255, 255, 255);" class="fills"/><g class="strokes"><path d="M170.208 45.23c0-3.239-2.613-5.865-5.836-5.865-3.224 0-5.837 2.626-5.837 5.865v.254c0 3.239 2.613 5.864 5.837 5.864 3.223 0 5.836-2.625 5.836-5.864v-.254Z" style="fill: none; stroke-width: 1.5; stroke: rgb(255, 255, 255); stroke-opacity: 1;" class="stroke-shape"/></g><path d="M141.911 47.376Za2.445 2.445 0 0 0 .963 3.227c.359.205.764.311 1.176.309h6.869c.413.002.817-.105 1.176-.309.359-.205.659-.5.873-.856a2.46 2.46 0 0 0 .092-2.369l-.006-.012-.006-.012-3.418-6.19a2.447 2.447 0 0 0-.873-.973 2.372 2.372 0 0 0-1.263-.372 2.38 2.38 0 0 0-1.267.363 2.444 2.444 0 0 0-.88.968l-3.436 6.226Z" style="fill: rgb(255, 255, 255);" class="fills"/><g class="strokes"><path d="M141.911 47.376Za2.445 2.445 0 0 0 .963 3.227c.359.205.764.311 1.176.309h6.869c.413.002.817-.105 1.176-.309.359-.205.659-.5.873-.856a2.46 2.46 0 0 0 .092-2.369l-.006-.012-.006-.012-3.418-6.19a2.447 2.447 0 0 0-.873-.973 2.372 2.372 0 0 0-1.263-.372 2.38 2.38 0 0 0-1.267.363 2.444 2.444 0 0 0-.88.968l-3.436 6.226Z" style="fill: none; stroke-width: 1.5; stroke: rgb(255, 255, 255); stroke-opacity: 1;" class="stroke-shape"/></g></g><g clip-path="url(#B)"><path d="M35.625 575.046c-.396 0-.782-.125-1.103-.358s-.559-.562-.681-.939-.122-.783.001-1.159a1.87 1.87 0 0 1 .683-.937c3.14-2.275 3.581-6.477 3.598-10.287.002-.496.201-.971.553-1.321s.828-.546 1.324-.545h.008a1.88 1.88 0 0 1 .717.146 1.87 1.87 0 0 1 .607.409c.173.175.311.382.404.61s.141.472.139.719c-.013 2.875-.041 9.607-5.15 13.305a1.86 1.86 0 0 1-1.1.357zm7.535 1.243a17.51 17.51 0 0 0 2.481-4.164c.195-.458.199-.974.013-1.436s-.548-.829-1.006-1.024-.974-.199-1.436-.013-.83.548-1.024 1.006c-.491 1.175-1.143 2.275-1.939 3.27-.313.386-.46.881-.408 1.375s.298.949.684 1.262.881.46 1.376.408.948-.298 1.262-.684h-.004zm4.26-12.298c.08-1.276.08-2.412.08-3.241a7.5 7.5 0 0 0-3.169-6.125 7.5 7.5 0 0 0-6.831-.947c-.236.079-.454.204-.641.368a1.88 1.88 0 0 0-.635 1.303 1.87 1.87 0 0 0 .483 1.366 1.89 1.89 0 0 0 .595.439 1.88 1.88 0 0 0 .718.175 1.89 1.89 0 0 0 .73-.116 3.73 3.73 0 0 1 1.766-.179 3.74 3.74 0 0 1 1.65.653c.49.346.889.805 1.165 1.338s.419 1.125.419 1.725c0 .824 0 1.849-.072 3.009a1.87 1.87 0 0 0 .097.726 1.88 1.88 0 0 0 .368.634 1.87 1.87 0 0 0 .583.444 1.88 1.88 0 0 0 .709.187h.116c.477 0 .936-.182 1.284-.509s.556-.774.586-1.25zm-16.556 6.704a5.93 5.93 0 0 0 2.308-.772c3.051-1.832 3.066-5.709 3.079-8.54.001-.247-.047-.491-.14-.719s-.231-.435-.404-.61a1.87 1.87 0 0 0-.607-.409 1.88 1.88 0 0 0-.717-.145h-.006c-.496 0-.972.197-1.323.547s-.55.825-.552 1.321c-.011 2.981-.215 4.715-1.25 5.338-.265.146-.557.238-.858.27-.473.06-.905.298-1.208.665s-.456.836-.427 1.312.239.922.586 1.248.805.509 1.281.51c.08 0 .16-.005.239-.016zm20.035 5.215a35.88 35.88 0 0 0 2.851-15.16 13.68 13.68 0 0 0-.968-5.067c-.184-.463-.543-.833-1-1.03s-.973-.204-1.435-.02a1.87 1.87 0 0 0-1.029 1c-.197.456-.204.972-.021 1.435.466 1.171.705 2.421.703 3.682a32.38 32.38 0 0 1-2.508 13.59c-.208.452-.228.968-.056 1.434s.523.846.974 1.054.968.229 1.434.056.846-.522 1.054-.974zM30 562.625v-1.875a10 10 0 0 1 1.302-4.933 9.99 9.99 0 0 1 8.469-5.063 9.99 9.99 0 0 1 4.962 1.189 1.88 1.88 0 0 0 1.416.129c.471-.145.865-.468 1.099-.901s.288-.941.151-1.414a1.87 1.87 0 0 0-.884-1.113c-2.095-1.128-4.446-1.692-6.824-1.639s-4.702.723-6.744 1.942a13.75 13.75 0 0 0-4.907 5.018c-1.174 2.068-1.791 4.406-1.792 6.785v1.875c0 .497.198.974.549 1.326s.829.549 1.326.549.974-.198 1.326-.549.549-.829.549-1.326z" fill="#fff"/></g><g fill="#fff"><path d="M364.142 565.493c.114.822.338 1.436.672 1.843.611.741 1.656 1.112 3.138 1.112.887 0 1.607-.098 2.161-.293 1.05-.375 1.575-1.071 1.575-2.088 0-.595-.261-1.054-.781-1.38-.521-.317-1.339-.598-2.455-.842l-1.904-.428c-1.873-.423-3.167-.883-3.883-1.38-1.213-.83-1.819-2.128-1.819-3.894 0-1.612.586-2.951 1.758-4.017s2.894-1.6 5.165-1.6c1.896 0 3.514.503 4.853 1.508s2.041 2.465 2.106 4.377h-3.614c-.065-1.082-.537-1.851-1.416-2.307-.586-.301-1.315-.452-2.186-.452-.968 0-1.742.195-2.32.586s-.866.936-.866 1.636c0 .643.284 1.124.854 1.441.367.212 1.148.46 2.345.745l3.101.744c1.359.326 2.385.761 3.077 1.307 1.074.847 1.611 2.071 1.611 3.675 0 1.644-.629 3.01-1.886 4.096s-3.034 1.63-5.33 1.63c-2.344 0-4.188-.535-5.531-1.605s-2.014-2.542-2.014-4.414h3.589z"/><path fill-rule="evenodd" d="M342 547v30h26.053v-2.763h-22.895v-24.474h22.895V547H342z"/></g><defs><style> @font-face { font-family: \'Quicksand\'; font-style: normal; font-weight: 700; font-display: swap; src: url(https://fonts.gstatic.com/s/quicksand/v30/6xKtdSZaM9iE8KbpRA_hK1QN.woff2) format(\'woff2\'); unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; } </style><clipPath id="A"><path fill="#fff" transform="translate(125 225)" d="M0 0h150v150H0z"/></clipPath><clipPath id="B"><path fill="#fff" transform="translate(25 547)" d="M0 0h30v30H0z"/></clipPath></defs> <text x="217.5" y="40" font-size="22.5" fill="#fff" text-anchor="middle" dominant-baseline="middle" style="font-family: \'Quicksand\', sans-serif;font-weight:700;">deGram</text> <text x="50%" y="400" font-size="25" fill="#fff" text-anchor="middle" dominant-baseline="middle" style="font-family: \'Quicksand\', sans-serif;font-weight:700;">';
    string constant svgCenter = '</text> <text x="50%" y="565" font-size="22.5" fill="#fff" text-anchor="middle" dominant-baseline="middle" style="font-family: \'Quicksand\', sans-serif;font-weight:700;">';
    string constant svgSuffix = '</text></svg>';

    /**
     * @dev Mapping to store profile addresses based on their names.
     */
    mapping(string => address) private _profiles;

    /**
     * @dev Mapping to track whether an address has claimed a profile.
     */
    mapping(address => bool) private _addressClaimed;

    /**
     * @dev Mapping to store the name associated with each address.
     */
    mapping(address => string) private _getNameWithAddress;

    /**
     * @dev Function to register a profile with a given name.
     * @param name The name of the profile to be registered.
     */
    function register(string calldata name) public onlyWhitelisted nonReentrant{
        uint256 len = StringUtils.strlen(name);
        require(len >= 3 && len <= 20, "Username must be at least 3 characters long and less than 20 characters");
        require(_profiles[name] == address(0), "Name already claimed");
        require(!_addressClaimed[msg.sender], "User has already claimed a profile");
        require(StringUtils.isAlphanumeric(name), "Name must contain only small letters and numbers");
        ++_counter;
        string memory finalSvg = string(
            abi.encodePacked(svgPrefix, name, svgCenter,Strings.toString(_counter),svgSuffix)
        );
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                name,
                '", "description": "DeGram Profile Name Testnet", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                Strings.toString(StringUtils.strlen(name)),
                '"}'
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        _setTokenURI(_counter, finalTokenUri);
        _profiles[name] = msg.sender;
        _addressClaimed[msg.sender]=true;
        _getNameWithAddress[msg.sender] = name;
        _safeMint(msg.sender, _counter);
    }

    /**
     * @dev Function to refer a user for whitelisting.
     * @param _address The address of the user to be referred.
     */
    function referWhitelist(address _address) public override {
        require(_addressClaimed[msg.sender], "User should have an deGram Profile");
        super.referWhitelist(_address);
    }

    /**
     * @dev Override function to prevent transfers of profiles.
     */
    function transferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public pure override(ERC721, IERC721) {
        revert("Transfers are not allowed");
    }

    /**
     * @dev Override function to prevent approvals of profiles.
     */
    function approve(address /*to*/, uint256 /*tokenId*/) public pure override(ERC721, IERC721) {
        revert("Approvals are not allowed");
    }

    /**
     * @dev Override function to prevent approvals for all profiles.
     */
    function setApprovalForAll(address /*operator*/, bool /*approved*/)public pure override(ERC721, IERC721){
        revert("Approvals are not allowed");
    }

    /**
     * @dev Function to retrieve the profile address associated with a given name.
     * @param _name The name of the profile.
     * @return The address of the profile owner.
     */
    function profiles(string calldata _name) public view returns(address){
        return _profiles[_name];
    }

    /**
     * @dev Function to check if an address has claimed a profile.
     * @param _address The address to check.
     * @return True if the address has claimed a profile, false otherwise.
     */
    function addressClaimed(address _address) public view returns(bool) {
        return _addressClaimed[_address];
    }

    /**
     * @dev Function to retrieve the name associated with an address.
     * @param _address The address to check.
     * @return The name associated with the address.
     */
    function getNameWithAddress(address _address) public view returns(string memory) {
        return _getNameWithAddress[_address];
    }
    
    /**
     * @dev Function to retrieve the current profile counter.
     * @return The number of profiles created so far.
     */
    function counter() public view returns(uint256){
        return _counter;
    }

}