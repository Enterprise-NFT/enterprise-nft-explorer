// SPDX-License-Identifier: GNU GPL v3
pragma solidity ^0.8.2;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/ERC721.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/access/Ownable.sol";

contract EnterpriseNFT is ERC721, ERC721URIStorage, Ownable {
    string purchaseRight1Status = "available";
    string purchaseRight2Status = "available";

    // string superAttributeX = ""

    constructor() ERC721("JPMEnterpriseNFT1", "JPMNFT1") {}

    function executePurchaseRight1() public {
        purchaseRight1Status = "consumed";
    }

    function executePurchaseRight2() public {
        purchaseRight2Status = "consumed";
    }

    function getPurchaseRight1Status() public view returns (string memory) {
        return purchaseRight1Status;
    }

    function getPurchaseRight2Status() public view returns (string memory) {
        return purchaseRight2Status;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}
