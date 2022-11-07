<h1 align="center">🤖Standard NFT Mint Contract🤖<h1/>

## License and prama 
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
```
## Import interface and libary from [@openzenppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
```js
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```
## State variables and modifier
```js
uint256 public immutable maxSupply; //The NFTs total supply
uint256 public immutable price;     //The price of a TokenId
string baseURI;                     //The url for metadata json
//Check Sender not a contract.
modifier callerIsUser() {
    require(!Address.isContract(_msgSender()), "Contract is unallowed.");
     _;
}
```
## Constructor
* _metaURI : baseURI > e.g. _ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/_
* _name : NFT name > e.g. _Board Ape yacht Club_
* _symbol : NFT symbol > e.g. _BAYC_
* _maxSupply : your NFT maxSupply > e.g. _10000 or 6666_
* _price: The Price for a NFT (_You should input wei_)
```js
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
```
## Mint function
Require :
1. The TokenId can't exceed to maxSupply
2. Price * _quantity can't exceed to msg.value  
```js
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
```
## Update metadata baseURI if you need.
```js
function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
}
```
## Withdraw ETH from this contract
```js
function withdraw() public payable onlyOwner {
    address sender = _msgSender();
    require(sender != address(0), "Withdraw address is zero.");
    uint256 amount = address(this).balance;
    Address.sendValue(payable(sender), amount);
}
```
---
<div>
  <h1 align="center">👇Click here and call Neal now !!!👇</h1>
  <a href="https://linktr.ee/evileye0666" target="_blank"><img src="../../Images/betterCallNeal.png" alt=""></a>
</div>
