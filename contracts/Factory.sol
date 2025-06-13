// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

contract Factory {
    uint256 public immutable fee;

    constructor(uint256 _fee) {
        fee = _fee;
    }
}
