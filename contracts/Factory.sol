// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Token} from  "./Token";

contract Factory {
    uint256 public immutable fee;
    address public owner;
    uint256 public totalTokens
    address[] public tokens


    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }
    function create(string memory _name, sting memory _symbol) {
        //Create a new token
        Token token = new Token(msg.sender,_name, _symbol, 1_000_000 ether)

        tokens.push(address(token))

        totalTokens++
    }
}
