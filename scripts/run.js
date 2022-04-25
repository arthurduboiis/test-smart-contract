
async function main() {

    const NFT = await hre.ethers.getContractFactory("UltimateChampionship");
    const nft = await NFT.deploy("Ultimate Polygon Championship", "URC", "ipfs://QmNk4Yzdxqj12rb19AGajPJiumhag83jeMkHV2LQS83SB4/");
  
    await nft.deployed();
  
    console.log("NFT deployed to:", nft.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  