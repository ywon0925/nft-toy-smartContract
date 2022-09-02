//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../node_modules/hardhat/console.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTBusinessCard is ERC721URIStorage {
    address payable owner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemSold;

    uint createFee = 0.01 ether;

    constructor() ERC721("NFTBusinessCard", "NFTM"){
        owner = payable(msg.sender);
    }

    struct BusinessCard {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyPublic;
    }

    mapping(uint256 => BusinessCard) private idToBusinessCard;

    function updateCreateFee(uint256 _createFee) public payable {
        require(owner == msg.sender, "Only owner can update the listing price");
        createFee = _createFee;
    }

    function getCreateFee() public view returns (uint256) {
        return createFee;
    }

    function getLatestIdToBusinessCard() public view returns (BusinessCard memory) {
        uint256 currentTokenId = _tokenIds.current();
        return idToBusinessCard[currentTokenId];
    }

    function getCardByTokenId(uint256 _tokenId) public view returns (BusinessCard memory) {
        return idToBusinessCard[_tokenId];
    }

    function getCurretCard() public view returns (uint256) {
        return _tokenIds.current();
    }

    function createToken(string memory _tokenURI, uint256 _price) public payable returns (uint){
        require(msg.value == createFee, "Send correct ammount of list");
        require(_price > 0, "Make sure price is not negative");

        _tokenIds.increment();
        uint256 currentTokenId = _tokenIds.current();
        _safeMint(msg.sender, currentTokenId);

        _setTokenURI(currentTokenId, _tokenURI);

        createBusinessCard(currentTokenId, _price);

        return currentTokenId;
    }
    
    function createBusinessCard(uint256 _tokenId,uint256 _price) private {
        idToBusinessCard[_tokenId] = BusinessCard(
            _tokenId,
            payable(address(this)),
            payable(msg.sender),
            _price,
            true
        );

        _transfer(msg.sender, address(this), _tokenId);
    }

    function getAllNFTs() public view returns (BusinessCard[] memory){
        uint nftCount = _tokenIds.current();
        BusinessCard[] memory tokens = new BusinessCard[](nftCount);
        for(uint i =0; i<nftCount; i++){
            BusinessCard storage currentItem = idToBusinessCard[i+1];
            tokens[i] = currentItem;
        }

        return tokens;
    }
}