// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Import OpenZeppel contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

// Inherit the OpenZeppel contract
contract MyEpicNFT is ERC721URIStorage {
  
  // Keep track of tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><defs><linearGradient id="logo-gradient" x1="50%" y1="0%" x2="50%" y2="100%" ><stop offset="0%" stop-color="#7A5FFF"><animate attributeName="stop-color" values="#7A5FFF; #01FF89; #7A5FFF" dur="4s" repeatCount="indefinite"></animate></stop><stop offset="100%" stop-color="#01FF89"><animate attributeName="stop-color" values="#01FF89; #7A5FFF; #01FF89" dur="4s" repeatCount="indefinite"></animate></stop></linearGradient></defs><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="url(\'#logo-gradient\')" /><text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">';

  string[] firstWords = ["Coarse", "Rough", "Irritating", "Sexual", "Smooth", "Thorough", "Shiny", "Lovely", "Hateful", "Stupid", "Smart", "Slow", "Everywhere", "Quick", "Slow"];
  string[] secondWords = ["Sand", "Anakin", "Obi-Wan", "Gold", "Red", "Blue", "Yellow", "Darth", "Leia", "Han", "Emperor", "Luke", "Jyn", "Lando", "Boba", "Jango", "Kylo"];
  string[] thirdWords = ["Skywalker", "Sand", "Fett", "Kenobi", "Leader", "Vader", "Sidious", "Organa", "Solo", "Palpatine", "Erso", "Calrissian", "Maul", "Ren", "Malak"];

  // Pass the name of our NFTs token and its symbol
  constructor() ERC721 ("SquareNFT", "SQUARE") {
      console.log("This is my NFT contract. Woah!");
  }

  // A function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // Seed the random generator
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }
  
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // Function our user will hit to get their NFT
  function makeAnEpicNFT() public {
    // Get the current tokenID, starts at 0
    uint256 newItemId = _tokenIds.current();

    // Randomly grab one word from each of the three arrays
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // Concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    // Actually mint the NFT to the sender using msg.sender
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted
    _tokenIds.increment();
  }

}