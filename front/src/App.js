import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import React, { useEffect, useState } from "react";
import { ethers } from 'ethers';
import myEpicNft from './utils/MyEpicNFT.json';

// Constants
const TWITTER_HANDLE = 'wl_devs';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = 'https://testnets.opensea.io/collection/squarenft-mrty74bp3f';
const TOTAL_MINT_COUNT = 50;
const CONTRACT_ADDRESS = "0xeA1BF00f718452ea90497BD33c5A696DeF6700B3";
const RINKEBY_CHAINID = "0x4";

const App = () => {

  const [currentAccount, setCurrentAccount] = useState("");
  const [mintedCount, _setMintedCount] = useState(0);
  const [isMinting, setIsMinting] = useState(false);
  const [latestMint, setLatestMint] = useState("");

  const mintedCountRef = React.useRef(mintedCount);

  const setMintedCount = x => {
    mintedCountRef.current = x;
    _setMintedCount(x);
  }

  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum)
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });
    let chainId = await ethereum.request({ method: 'eth_chainId' });
      console.log("Connected to chain " + chainId);
      if (chainId !== RINKEBY_CHAINID) {
        alert("You are not connected to the Rinkeby Test Network!");
      }

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
      
      // Setup listener for the case where a user comes to our site and
      // already and already had their wallet connected + authorized
      setupEventListener();
    } else {
      console.log("No authorized account found");
    }
  }

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum ) {
        alert("Get MetaMask!");
        return;
      }

      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      let chainId = await ethereum.request({ method: 'eth_chainId' });
      console.log("Connected to chain " + chainId);
      if (chainId !== RINKEBY_CHAINID) {
        alert("You are not connected to the Rinkeby Test Network!");
      }

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
      
      // Setup listener for the case where a user comes to our site and
      // connected their wallet for the first time
      setupEventListener();
    } catch (error) {
      console.log(error);
    };
  }

  const setupEventListener = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        let count = await connectedContract.getCurrMinted();

        setMintedCount(count.toNumber());

        // This will essentially "capture" our event when our contract throws it.
        connectedContract.on("NewEpicNFTMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          setLatestMint(`https://rinkeby.rarible.com/token/${CONTRACT_ADDRESS}:${tokenId.toNumber()}`);
          setMintedCount(mintedCountRef.current + 1);
        });

        console.log("Setup event listener!")

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToMintNft = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        console.log("Going to pop wallet now to pay gas...");
        let nftTxn = await connectedContract.makeAnEpicNFT();

        setIsMinting(true);
        console.log("Mining...please wait.");
        await nftTxn.wait();

        setIsMinting(false);
        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error);
    }
  }

  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);   

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My NFT Collection</p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your NFT today.
          </p>
          {currentAccount === "" ? (
            <button onClick={connectWallet} className="cta-button connect-wallet-button">
              Connect to Wallet
            </button>
          ) : (
            <>
            <p className="sub-text" style={{'marginTop': 0, 'marginBottom': 0}}>
              Minted so far:
            </p>
            <p className="header gradient-text">
            {mintedCount} / {TOTAL_MINT_COUNT}
            </p>
            <div style={{"height": "120px", "display": "flex", "alignItems": "center", "justifyContent": "center"}}>
            {isMinting ? 
              <>
              <p className="sub-text">Minting...</p><br/>
              <div class="lds-roller"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
              </>
              : 
              <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
              Mint NFT
              </button>}
            </div>
            <br/>
            <button onClick={() => {window.location = OPENSEA_LINK}} className="cta-button connect-wallet-button">
            🌊 View Collection on OpenSea
            </button>
            <br/>
            <br/>
            </>
          )}
          {latestMint === "" ? <></> :
          <button onClick={() => {window.location = latestMint}} className="cta-button connect-wallet-button">Most recently minted NFT</button>}
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built by @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;
