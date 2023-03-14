const { ethers, upgrades } = require('hardhat');

async function main() {
  // Deploy MKP token
  const MKPFactory = await ethers.getContractFactory('MKP');
  const mkp = await MKPFactory.deploy();
  await mkp.deployed();

  // Deploy GEM token
  const GEMFactory = await ethers.getContractFactory('GEM');
  const gem = await GEMFactory.deploy();
  await gem.deployed();

  // Deploy NFT A token
  const NFTAFactory = await ethers.getContractFactory('NFTA');
  const nfta = await NFTAFactory.deploy();
  await nfta.deployed();

  // Deploy NFT B token
  const NFTBFactory = await ethers.getContractFactory('NFTB');
  const nftb = await NFTBFactory.deploy();
  await nftb.deployed();

  // Deploy NFT marketplace
  const whale1 = "0x00000000219ab540356cbb839cbe05303d7705fa";
  const whale2 = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
  const whale3 = "0xbe0eb53f46cd790cd13851d5eff43d12404d33e8";
  const NFTMarketplaceFactory = await ethers.getContractFactory('NFTMarketplace');
  const nftMarketplaceProxy = await upgrades.deployProxy(NFTMarketplaceFactory, [mkp.address, gem.address, nfta.address, nftb.address, whale1, whale2, whale3]);
  await nftMarketplaceProxy.deployed();
  // await upgrades.upgradeProxy("0x0a97c9A38699144dD5982dAe978fa4064cFCeb6a", NFTMarketplaceFactory);

  // set marketplace address in NFT B
  await nftb.setMarketplace(nftMarketplaceProxy.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
