// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "https://raw.githubusercontent.com/distributed-ledger-technology/solidity-logger/main/src/logger.sol";

contract Fiduciary is Loggable {
    struct offer {
        address nftAddress;
        address origin;
        uint256 bid;
    }

    offer[] offers;

    address[] nftsUnderManagement = [
        0xf1bACa82543f5F3D934d610244974A836b673834,
        0xd3cFBA277aAE616DA25F45bcC064e8465601bDeE,
        0xc42159B2a7A68A389B2e555d94B020c2971D18Ad
    ];

    address[] allowedWalletAddressesForInitialBuying = [
        0xaACF20b4dA001B1A82B2BD0De43aC06DA4946c01,
        0x6c2483741dc2A34F2A8D95496e15AEf6a3d79ABf
    ]; // known customers identity wise ...

    function getNFTsUnderManagement() public view returns (address[] memory) {
        return nftsUnderManagement;
    }

    function makeOffer(address nftAddress) public payable {
        // offer currentOffer = new offer(nftAddress, bid);

        // offer memory currentOffer = offer{nftAddress: nftAddress, bid: bid};

        offer memory currentOffer = offer(nftAddress, msg.sender, msg.value);

        offers.push(currentOffer);

        // reinladen der Kohle
    }

    function acceptOffer() public {
        // transferOwnership from user wallet to fiduciary...
        // reinladen des NFTs
    }

    function triggerExchange() internal {
        // transfer NFT Ownership from fiduciary sc to new owner
        // transfer offer price from fiduciary sc to NFT seller
    }

    function getOffers() public view returns (offer[] memory) {
        return offers;
    }

    function claimOfferPriceBack() public {
        //
    }

    function claimNFTBack() public {
        //
    }
}
