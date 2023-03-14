require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-watcher");
require("hardhat-gas-reporter");
require('solidity-coverage');
require('@openzeppelin/hardhat-upgrades');
require('hardhat-storage-layout');

const { alchemyApiKey, privateKey, etherscanApiKey } = require('./secrets.json');

module.exports = {
  solidity: "0.8.18",
  networks: {
    polygonMumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${alchemyApiKey}`,
      accounts: [privateKey]
    },
    hardhat: {
      initialBaseFeePerGas: 0,
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: `${etherscanApiKey}`
    },
  }
};
