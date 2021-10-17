const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  let count = await nftContract.getCurrMinted();
  console.log(`${count} NFTs minted so far`);

  // Call the function and wait for it to be mined
  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();

  count = await nftContract.getCurrMinted();
  console.log(`${count} NFTs minted so far`);

  // Mint second NFT
  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();