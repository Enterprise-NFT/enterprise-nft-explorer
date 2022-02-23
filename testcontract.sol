// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "https://raw.githubusercontent.com/distributed-ledger-technology/solidity-logger/main/src/logger.sol";



contract Fiduciary is Loggable {
    //offer example: [123, "Open", "Hello", 234, 0x872522AA1Cb49fE46a5C9D7A1Ab8Dc0F40bd8350, 34534]
    // [123, "Open", "Hello", 0x872522AA1Cb49fE46a5C9D7A1Ab8Dc0F40bd8350, 34534]
    // [123, "Open", "Hello", 345, 0x872522AA1Cb49fE46a5C9D7A1Ab8Dc0F40bd8350, 34534]
    struct offer {
        uint256 id;
        string status;
        string note;
        uint256 offerPrice;
        address relatedAsset;
        uint256 validUnitl; //enter date in unixTimestamp / millis
    }

    struct nftsUnderManagement {
        address contractId;
        PurchaseStatus status;
    }

    nftsUnderManagement[] totalNFTs;

    //mint: 1 NFT -> deploy ERC721 + on fid.register(erc721.address)

    function registerNewNFT(address nftAddress) public  { 
        //check if address matches to project?
        totalNFTs.push(nftsUnderManagement(nftAddress,   PurchaseStatus.Open));
    }

    enum PurchaseStatus { Open, Consumed, Undefined}

    PurchaseStatus status = PurchaseStatus.Open;

    function getPurchaseStatus(address nftAddress) public view returns (PurchaseStatus){
        for(uint i = 0;  i < totalNFTs.length; i++) {
            if(totalNFTs[i].contractId == nftAddress) {
                return totalNFTs[i].status;
            }
        }
        return PurchaseStatus.Undefined;
    }

    function consumeRights(address nftAddress) public {
         for(uint i = 0;  i < totalNFTs.length; i++) {
            if(totalNFTs[i].contractId == nftAddress) {
                totalNFTs[i].status = PurchaseStatus.Consumed;
            }
        }
    }


    offer[] offers;

    function makeOfferWith(offer memory myOffer) public {
        offers.push(myOffer);
  
    }

    function getOffers() public view returns (offer[] memory){
      /*  for(uint i = 0;  i < offers.length; i++) {
            log(offers[i].note);
        }*/
        return offers;
    }

    function acceptOffer(uint8 id) public {
        for(uint i = 0;  i < offers.length; i++) {
            if(offers[i].id == id) {
                log(offers[i].note);
            }
        }
    }

}
