# NN NFTMarketplace protocol
NN NFTMarketplace which can list, purchase and upgrade NFTs


## Installation

To run this application, you need to have NPM (or Yarn) installed on your computer.

```
cd frontend
npm install
```

Create a secrets.json file in the root directory and add necessary keys

## Deployment

To deploy mock tokens and nft marketplace contract

`npx hardhat run ./scripts/deploy.js --network polygonMumbai`


## Run the script

To run the scripts

`npx hardhat run ./scripts/script.js --network polygonMumbai`

## Verify the contracts in polygonscan

`npx hardhat verify --CONTRACT_ADDRESS --network polygonMumbai`

## License
