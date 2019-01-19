pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {

    string public constant name = "Jimmy's Udacity Token";
    string public constant symbol = "JUT";

    mapping(uint256 => string) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, uint256 _tokenId) public {

        tokenIdToStarInfo[_tokenId] = _name;

        _mint(msg.sender, _tokenId);
    }


    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function lookUpTokenIdToStarInfo(uint256 _tokenId) public returns (string){
        return tokenIdToStarInfo[_tokenId];
    }

    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public{
        address starOwner1 = this.ownerOf(_tokenId1);
        address starOwner2 = this.ownerOf(_tokenId2);
        address approvedAddressStar2 = getApproved(_tokenId2);
        require(msg.sender == starOwner1, "the sender needs to be the owner of the star 1");
        require(msg.sender == approvedAddressStar2, "the sender needs to be approved for the star 2");

        safeTransferFrom(starOwner1, starOwner2, _tokenId1);
        safeTransferFrom(starOwner2, starOwner1, _tokenId2);
    }

    function transferMyStar(address _to, uint256 _tokenId) public {
        address starOwner = this.ownerOf(_tokenId);
        require(msg.sender == starOwner, "the sender needs to be the owner of the start");

        safeTransferFrom(msg.sender, _to, _tokenId);
    }
}