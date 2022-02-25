// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "https://raw.githubusercontent.com/distributed-ledger-technology/solidity-logger/main/src/logger.sol";

contract Fiduciary is Loggable {
    address[] nftsUnderManagement = [
        0x3e3206608d7fd3ba19580704d3503abebf8284ba,
        0xc5e961ad6019c42cafd7609f3517be5cd0f767d8
    ];

    address[] allowedWalletAddressesForInitialBuying = []; // known customers identity wise ...

    function getNFTsUnderManagement() public view returns (string[] memory) {
        return nftsUnderManagement;
    }
}
