// SPDX-License-Identifier: GNU GPL v3
pragma solidity ^0.8.2;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/ERC721.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/access/Ownable.sol";

contract JPMEnterpriseNFT is ERC721, ERC721URIStorage, Ownable {
    string purchaseRight1Status = "available";
    string purchaseRight2Status = "available";

    // mapping(address => uint) offers;

    struct offer {
        address payable from;
        uint256 amount;
    }

    offer[] offers;

    constructor() ERC721("JPM Development NFT 3", "JPMNFT3") {}

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

    function makeOffer() external payable {
        offer memory highestOffer = this.getHighestOffer();
        require(msg.value > highestOffer.amount);

        offers.push(offer(payable(msg.sender), msg.value));
    }

    function getHighestOffer() public view returns (offer memory) {
        uint256 i = 0;
        offer memory highestOffer = offers[i];
        for (i; i < offers.length; i++) {
            if (highestOffer.amount < offers[i].amount) {
                highestOffer = offers[i];
            }
        }
        return highestOffer;
    }

    function acceptHighestOffer() external {
        offer memory highestOffer = this.getHighestOffer();

        payable(this.owner()).transfer(highestOffer.amount); // transfers the money of the highest offer to the seller

        this.transferOwnership(highestOffer.from); // transfers the NFT

        // tbd delete the entry from offers array
    }

    function claimOfferAmountBack() public {
        uint256 i = 0;
        uint256 amountToBeSentBack = 0;

        for (i; i < offers.length; i++) {
            if (offers[i].from == msg.sender) {
                amountToBeSentBack += offers[i].amount;
            }
        }
        payable(msg.sender).transfer(amountToBeSentBack); // transfers the money of the other offers back

        // tbd delete the entry from offers array
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
