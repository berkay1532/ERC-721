// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Chainify is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public maxSupply = 1;
    bool public allowListMintOpen = false;
    bool public publicMintOpen = false;


    constructor() ERC721("Chainify", "CHF") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editTypeOfMintOpen(bool _allowListMintOpen, bool _publicMintOpen) external onlyOwner {
        allowListMintOpen = _allowListMintOpen;
        publicMintOpen = _publicMintOpen;
    }

    function allowListMint() public payable {
        require(msg.value == 0.00001 ether, "Not enough funds");
        require(totalSupply() < maxSupply, "Sold out");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }


    function publicMint() public payable {
        require(msg.value == 0.0001 ether, "Not enough funds");
        require(totalSupply() < maxSupply, "Sold out");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }


    function withdraw(address _addr) external onlyOwner {
        uint balance = address(this).balance;

        payable(_addr).transfer(balance);
    }


    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}