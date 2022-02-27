// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "https://raw.githubusercontent.com/distributed-ledger-technology/solidity-logger/main/src/logger.sol";

contract Fiduciary is Loggable {
    struct offer {
        address nftAddress;
        uint256 bid;
    }

    offer[] offers;

    address[] nftsUnderManagement = [
        0xb6d0bFc10F4a58E2d5Fd596127CDfb23Becad833,
        0x40Da03fdD198FaE79D36B2a3e931856fc47A0EeE,
        0xc16e757C261b5249bF801d5E2Ae76C05faC05fE4
    ];

    address[] allowedWalletAddressesForInitialBuying = [
        0xaACF20b4dA001B1A82B2BD0De43aC06DA4946c01,
        0x6c2483741dc2A34F2A8D95496e15AEf6a3d79ABf
    ]; // known customers identity wise ...

    function getNFTsUnderManagement() public view returns (address[] memory) {
        return nftsUnderManagement;
    }

    function makeOffer(address nftAddress, uint256 bid) public {
        // offer currentOffer = new offer(nftAddress, bid);

        // offer memory currentOffer = offer{nftAddress: nftAddress, bid: bid};

        offer memory currentOffer = offer(nftAddress, bid);

        offers.push(currentOffer);
    }

    function acceptOffer() public {
        // transferOwnership
    }

    function getOffers() public view returns (offer[] memory) {
        return offers;
    }
}
