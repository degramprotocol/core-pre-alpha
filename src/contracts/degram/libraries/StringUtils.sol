/*
 SPDX-License-Identifier: MIT
*/
pragma solidity 0.8.20;

/**
 * @title String Utilities Library
 * @dev Provides utility functions for string manipulation.
 */
library StringUtils {

    /**
     * @dev Calculates the length of a string by counting its UTF-8 characters.
     * @param s The input string.
     * @return The length of the string.
     */
    function strlen(string memory s) internal pure returns (uint) {
        uint len;
        uint i = 0;
        uint bytelength = bytes(s).length;
        for(len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            if(b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }
        return len;
    }

    /**
     * @dev Checks if a string contains only alphanumeric characters (a-z, A-Z, 0-9).
     * @param str The input string.
     * @return True if the string is alphanumeric, false otherwise.
     */
    function isAlphanumeric(string memory str) internal pure returns (bool) {
        bytes memory bStr = bytes(str);
        for (uint i = 0; i < bStr.length; i++) {
            // Check if the character is a lowercase letter (a-z) or a number (0-9)
            if ((bStr[i] < 0x30 || bStr[i] > 0x39) && (bStr[i] < 0x61 || bStr[i] > 0x7A)) {
                return false;
            }
        }
        return true;
    }

    
}