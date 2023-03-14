const { ethers, upgrades } = require('hardhat');

async function main() {
    const mkp = await ethers.getContractAt('MKP', "0xF4c8Ce70A834A37A19d010d011C133295E9A6630");
    const gem = await ethers.getContractAt('GEM', "0x104a3489Ea010220E6BA3845890557a57678bFe3");
    const nfta = await ethers.getContractAt('NFTA', "0x45507daac6d00a8975b41b7df673f4a831b00700");
    const nftb = await ethers.getContractAt('NFTB', "0x18eeac20a02e513961f2775f6c38864df9b5ec96");
    const nftMarketplace = await ethers.getContractAt('NFTMarketplace', "0x0a97c9A38699144dD5982dAe978fa4064cFCeb6a");

    // list token 1 of NFT A from seller
    await nfta.approve(nftMarketplace.address, 1);
    await nftMarketplace.listNFT(1, "100000000000000000000");
    await mkp.transfer("0x681220A950BC5014459Af295bDe42eB684a31347", "1000000000000000000000");
    await gem.transfer("0x681220A950BC5014459Af295bDe42eB684a31347", "10000000000000000000000");
    
    // Purchase token 1 from buyer
    await mkp.approve(nftMarketplace.address, "100000000000000000000");
    await nftMarketplace.purchaseNFT(1);

    // Upgrade token 1
    await gem.approve(nftMarketplace.address, "1000000000000000000000");
    await nftMarketplace.upgradeNFT(1);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
