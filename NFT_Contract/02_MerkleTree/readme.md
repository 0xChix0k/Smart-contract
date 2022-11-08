<h1 align="center">🤖NFT mint contract by merkle tree whitelist🤖<h1/>

## License and prama 
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
```
## Import interface and libary from [@openzenppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
```js
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
```
## State variables and modifier
```js
mapping(address => bool) public isMinted; //Address minted or not
bytes32 public immutable root;            //merkle tree root
uint256 public immutable maxSuppply;      //The NFTs Max supply
uint256 public immutable preSaleMax;      //Max supply for Pre sale
uint256 public immutable preSaleMaxMint;  //Max tokens to mint for a wallet in pre sale 
uint256 public price;                    //The price of a TokenId
uint256 public mintTime;                 //The time to mint
bool public preMintOpen;                 //The target for pre sale
bool public pubMintOpen;                 //The target for pub sale
string baseURI;                          //The url for metadata json
//Check Sender not a contract.
modifier callerIsUser() {
  require(!Address.isContract(_msgSender()), "Contract is unallowed.");
    _;
}
```
## Constructor
```js
constructor(
  string memory _metaURI,
  string memory _name,
  string memory _symbol,
  uint256 _maxSuppply,
  uint256 _preSaleMax,
  uint256 _preSaleMaxMint,
  uint256 _price,
  uint256 _mintTime,
  bytes32 _merkleRoot
) payable ERC721(_name, _symbol) {
  baseURI = _metaURI;
  maxSuppply = _maxSuppply;
  preSaleMax = _preSaleMax;
  preSaleMaxMint = _preSaleMaxMint;
  price = _price;
  mintTime = _mintTime;
  preMintOpen = !preMintOpen;
  root = _merkleRoot;
}

```
* _metaURI : baseURI > e.g. _ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/_
* _name : NFT name > e.g. _Board Ape yacht Club_
* _symbol : NFT symbol > e.g. _BAYC_
* _maxSupply : MaxSupply of The NFT > e.g. _10000 or 6666_
* _preSaleMax : MaxSupply of The NFT in presale > e.g. _3333_
* _preSaleMaxMint : A wallet max mint for presale > e.g. _3_
* _price: The Price for a NFT (_You should input wei_)
* _mintTime : The time to mint > e.g. _1672416000_ (timestamp)
* _merkleRoot : The root of merkle tree

## Premint function
```js
function preMint(uint256 _quantity, bytes32[] calldata proof) external payable nonReentrant callerIsUser {
  address sender = _msgSender();
  bool minted = isMinted[sender];
  require(preMintOpen, 'Premint close now.');
  require(MerkleProof.verify(proof, root, _leaf(sender)), 'The address not in whitelist.');
  require(!minted, 'The address have been minted');
  require(_quantity <= preSaleMaxMint, 'Exceed to preSaleMaxMint.');
  require(totalSupply() + _quantity <= preSaleMax, 'Exceed to preSaleMax.');
  isMinted[sender] = true;
  _minNFT(sender, _quantity);
}
```
Require :
1. preMintOpen == true.
2. MerkleProof.verify == true.
3. isMinted[sender] ==false. (Not mint yet.)
4. _quantity can't exceed to preSaleMaxMint.
5. totalSupply() + _quantity can't exceed to preSaleMax 

## Pubmint function
```js
function pubMint(uint256 _quantity) external payable callerIsUser nonReentrant {
  require(pubMintOpen, 'Public mint not open yet.');
  require(totalSupply() + _quantity <= maxSuppply, 'Exceed to MaxSupply');
  _minNFT(_msgSender(), _quantity);
}
```
Require :
1. pubMintOpen == true.
2. totalSupply() + _quantity can't exceed to preSaleMax 

## _minNFT function (internal)
```js
function _minNFT(address _addr, uint256 _quantity) internal {
  uint256 tokenId = totalSupply();
  require(block.timestamp >= mintTime, 'Too early to mint.');
  require(price * _quantity <= msg.value, 'The value is not correct.');
  for (uint256 i = 0; i < _quantity; i++) {
      _safeMint(_addr, tokenId + i);
  }
}
```
Require :
1. Now time >= mintTime.
2. price * _quantity <= msg.value.

## Set function by Owner 
```js
function setMintTime(uint256 _mintTime) public onlyOwner {
  mintTime = _mintTime;
}
```
Set new price(ETH)
```js
function setMintPrice(uint256 _price) public onlyOwner {
  price = _price;
}
```
Update metadata baseURI.
```js
function setBaseURI(string memory _newBaseURI) public onlyOwner {
  baseURI = _newBaseURI;
}
```
Set pre sale status
```js
function preMintTarget() public onlyOwner {
  preMintOpen = !preMintOpen;
}
```
Set pub sale status
```js
function pubMintTarget() public onlyOwner {
  pubMintOpen = !pubMintOpen;
}
```
Withdraw from contract
```js
function withdraw() public payable onlyOwner {
  uint256 amount = address(this).balance;
  Address.sendValue(payable(_msgSender()), amount);
}
```
---
<div>
  <h1 align="center">👇Click here and call Neal now !!!👇</h1>
  <a href="https://linktr.ee/evileye0666" target="_blank"><img src="../../Images/betterCallNeal.png" alt=""></a>
</div>
