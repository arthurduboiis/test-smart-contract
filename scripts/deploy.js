const tokens = require('./tokens.json');
const hre = require("hardhat");
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

async function main() {

  let tab = [];
  tokens.map(token => {
    tab.push(token.address);
    console.log("added to wl :", token.address)
  })

  const leaves = tab.map(address => keccak256(address));
  const tree = new MerkleTree(leaves, keccak256, { sort: true});
  const root = tree.getHexRoot();
  
  const NFT = await hre.ethers.getContractFactory("NFTERC721A");
  const nft = await NFT.deploy(tab, [20,50,30], root, "ipfs://QmNk4Yzdxqj12rb19AGajPJiumhag83jeMkHV2LQS83SB4/");

  await nft.deployed();

  console.log("NFT deployed to:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
