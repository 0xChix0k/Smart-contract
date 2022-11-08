// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Github: @Evileye0666
contract Simple is ERC721Enumerable, Ownable, ReentrancyGuard {
    uint256 public immutable maxSupply;
    uint256 public immutable price;
    string baseURI;
    //only user
    modifier callerIsUser() {
        require(!Address.isContract(_msgSender()), "Contract is unallowed.");
        _;
    }

    //Constructor input
    //_metaURI : baseURI > like ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
    //_name : NFT name > like Board Ape yacht Club
    //_symbol : NFT symbol > loike BAYC
    //_maxSupply : your NFT maxSupply > like 10000 or 6666
    //_price : The Price for A NFT of Mint
    constructor(
        string memory _metaURI,
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        uint256 _price
    ) payable ERC721(_name, _symbol) {
        baseURI = _metaURI;
        maxSupply = _maxSupply;
        price = _price;
    }

    //Mint NFT
    function NftMint(uint256 _quantity)
        external
        payable
        callerIsUser
        nonReentrant
    {
        uint256 tokenId = totalSupply();
        require(tokenId + _quantity <= maxSupply, "Exceed To MaxSupply.");
        uint256 totalPrice_ = price * _quantity;
        require(totalPrice_ <= msg.value, "Value is Not Right.");
        address minter = _msgSender();
        for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(minter, tokenId + i);
        }
    }

    //set a new baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //Withdraw
    function withdraw() public payable onlyOwner {
        address sender = _msgSender();
        require(sender != address(0), "Withdraw address is zero.");
        uint256 amount = address(this).balance;
        Address.sendValue(payable(sender), amount);
    }
}
