// SPDX-License-Identifier: GNU GPL v3
pragma solidity ^0.8.2;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/ERC721.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.5.0/contracts/access/Ownable.sol";
import "https://raw.githubusercontent.com/distributed-ledger-technology/solidity-logger/main/src/logger.sol";

contract JPMEnterpriseNFT is ERC721, ERC721URIStorage, Ownable {
    string purchaseRight1Status = "available";
    string purchaseRight2Status = "available";
    address[] developerWallets = [0xaACF20b4dA001B1A82B2BD0De43aC06DA4946c01];
    // mapping(address => uint) offers;

    struct offer {
        address payable from;
        uint256 amount;
        bool obsolete;
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

    function makeOffer() public payable {
        // require(msg.value > 5000000000000000000000);

        if (offers.length > 0) {
            offer memory highestOffer = this.getHighestOffer();
            require(msg.value > highestOffer.amount);
        } else {
            require(msg.value > 0);
        }

        offers.push(offer(payable(msg.sender), msg.value, false));
    }

    function getOffers() public view returns (offer[] memory) {
        return offers;
    }

    function getHighestOffer() public view returns (offer memory) {
        uint256 i = 0;
        offer memory highestOffer = offers[i];
        for (i; i < offers.length; i++) {
            if (
                highestOffer.amount < offers[i].amount &&
                offers[i].obsolete == false
            ) {
                highestOffer = offers[i];
            }
        }
        return highestOffer;
    }

    function acceptHighestOffer() external {
        offer memory highestOffer = this.getHighestOffer();

        uint256 transferredReward = rewardDevelopersAndOperators(
            highestOffer.amount * 0.01
        );

        payable(this.owner()).transfer(highestOffer.amount - transferredReward); // transfers the money of the highest offer to the seller

        this.transferOwnership(highestOffer.from); // transfers the NFT

        uint256 i = 0;

        for (i; i < offers.length; i++) {
            if (offers[i].from == msg.sender && offers[i].obsolete == false) {
                offers[i].obsolete = true;
            }
        }
    }

    function rewardDevelopersAndOperators(uint256 amount)
        public
        returns (uint256)
    {
        uint256 j = 0;
        uint256 individualReward = amount / developerWallets.length;
        uint256 transferredReward;

        for (j; j < developerWallets.length; j++) {
            developerWallets[j].transfer(individualReward);
            transferredReward += individualReward;
        }

        return transferredReward;
    }

    function claimOfferAmountBack() public {
        uint256 i = 0;
        uint256 amountToBeSentBack = 0;

        for (i; i < offers.length; i++) {
            if (offers[i].from == msg.sender && offers[i].obsolete == false) {
                amountToBeSentBack += offers[i].amount;
                offers[i].obsolete = true;
            }
        }
        payable(msg.sender).transfer(amountToBeSentBack); // transfers the money of the other offers back
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
