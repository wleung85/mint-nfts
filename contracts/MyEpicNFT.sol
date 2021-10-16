// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Import OpenZeppel contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Inherit the OpenZeppel contract
contract MyEpicNFT is ERC721URIStorage {
  
  // Keep track of tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // Pass the name of our NFTs token and its symbol
  constructor() ERC721 ("SquareNFT", "SQUARE") {
      console.log("This is my NFT contract. Woah!");
  }

  // Function our user will hit to get their NFT
  function makeAnEpicNFT() public {
    // Get the current tokenID, starts at 0
    uint256 newItemId = _tokenIds.current();

    // Actually mint the NFT to the sender using msg.sender
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data
    _setTokenURI(newItemId, "https://jsonkeeper.com/b/C38C");
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted
    _tokenIds.increment();
  }

}