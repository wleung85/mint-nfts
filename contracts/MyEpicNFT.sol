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
    _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJQ0FnUEdSbFpuTStJQ0FLSUNBZ0lDQWdJQ0E4YkdsdVpXRnlSM0poWkdsbGJuUWdhV1E5SW14dloyOHRaM0poWkdsbGJuUWlJSGd4UFNJMU1DVWlJSGt4UFNJd0pTSWdlREk5SWpVd0pTSWdlVEk5SWpFd01DVWlJRDRnQ2lBZ0lDQWdJQ0FnSUNBZ0lEeHpkRzl3SUc5bVpuTmxkRDBpTUNVaUlITjBiM0F0WTI5c2IzSTlJaU0zUVRWR1JrWWlQZ29nSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdQR0Z1YVcxaGRHVWdZWFIwY21saWRYUmxUbUZ0WlQwaWMzUnZjQzFqYjJ4dmNpSWdkbUZzZFdWelBTSWpOMEUxUmtaR095QWpNREZHUmpnNU95QWpOMEUxUmtaR0lpQmtkWEk5SWpSeklpQnlaWEJsWVhSRGIzVnVkRDBpYVc1a1pXWnBibWwwWlNJK1BDOWhibWx0WVhSbFBnb2dJQ0FnSUNBZ0lDQWdJQ0E4TDNOMGIzQStDaUFnSUNBZ0lDQWdJQ0FnSUR4emRHOXdJRzltWm5ObGREMGlNVEF3SlNJZ2MzUnZjQzFqYjJ4dmNqMGlJekF4UmtZNE9TSStDaUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQThZVzVwYldGMFpTQmhkSFJ5YVdKMWRHVk9ZVzFsUFNKemRHOXdMV052Ykc5eUlpQjJZV3gxWlhNOUlpTXdNVVpHT0RrN0lDTTNRVFZHUmtZN0lDTXdNVVpHT0RraUlHUjFjajBpTkhNaUlISmxjR1ZoZEVOdmRXNTBQU0pwYm1SbFptbHVhWFJsSWo0OEwyRnVhVzFoZEdVK0NpQWdJQ0FnSUNBZ0lDQWdJRHd2YzNSdmNENEtJQ0FnSUNBZ0lDQThMMnhwYm1WaGNrZHlZV1JwWlc1MFBpQUtJQ0FnSUR3dlpHVm1jejRLSUNBZ0lEeHpkSGxzWlQ0dVltRnpaU0I3SUdacGJHdzZJSGRvYVhSbE95Qm1iMjUwTFdaaGJXbHNlVG9nYzJWeWFXWTdJR1p2Ym5RdGMybDZaVG9nTVRSd2VEc2dmVHd2YzNSNWJHVStDaUFnSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSjFjbXdvSnlOc2IyZHZMV2R5WVdScFpXNTBKeWtpSUM4K0NpQWdJQ0E4ZEdWNGRDQjRQU0kxTUNVaUlIazlJalV3SlNJZ1kyeGhjM005SW1KaGMyVWlJR1J2YldsdVlXNTBMV0poYzJWc2FXNWxQU0p0YVdSa2JHVWlJSFJsZUhRdFlXNWphRzl5UFNKdGFXUmtiR1VpUGtWd2FXTk1iM0prU0dGdFluVnlaMlZ5UEM5MFpYaDBQZ284TDNOMlp6ND0iCn0=");
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted
    _tokenIds.increment();
  }

}