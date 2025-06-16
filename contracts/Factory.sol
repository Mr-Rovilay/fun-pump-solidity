// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Token} from "./Token.sol";

contract Factory {
    uint256 public immutable fee;
    address public owner;
    uint256 public totalTokens;
    address[] public tokens;

    mapping(address => TokenSale) public tokenToSale;

    struct TokenSale {
        address token;
        string name;
        address creator;
        uint256 sold;
        uint256 raised;
        bool isOpen;
    }

    event Created(address indexed token);
    event Buy(address indexed token, uint256 amount);

    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }

    function getTokenSale(
        uint256 _index
    ) public view returns (TokenSale memory) {
        return tokenToSale[tokens[_index]];
    }

    function create(
        string memory _name,
        string memory _symbol
    ) external payable {
        require(msg.value >= fee);        //Create a new token
        Token token = new Token(msg.sender, _name, _symbol, 1_000_000 ether);

        tokens.push(address(token));

        totalTokens++;
        //list token sale for sale
        TokenSale memory sale = TokenSale(
            address(token),
            _name,
            msg.sender,
            0,
            0,
            true
        );

        tokenToSale[address(token)] = sale;

        emit Created(address(token));
    }

    function buy(address _token, uint256 _amount) external payable {

        TokenSale storage sale = tokenToSale[_token];

        uint256 cost = getCost(sale.sold);
        // require(sale.isOpen, "Sale is not open");

        uint256 price = cost * (_amount / 10 ** 18);
        // require(msg.value >= price, "Not enough ether sent");
        // require(Token(_token).balanceOf(address(this)) >= _amount, "Not enough tokens in sale");

        sale.sold = sale.sold + _amount;
        sale.raised = sale.raised + price;
        // if (msg.value > price) {
        //     payable(msg.sender).transfer(msg.value - price); // Refund excess ether
        // }
        // if (sale.sold >= 1_000_000 ether) {
        //     sale.isOpen = false; // Close the sale if all tokens are sold
        // }
        // Transfer the fee to the owner
        Token(_token).transfer(msg.sender, _amount);

        emit Buy(_token, _amount);
    }
}
