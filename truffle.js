const HDWalletProvider = require('truffle-hdwallet-provider');

let mnemonic = '';

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    ganache: {
      provider: new HDWalletProvider(mnemonic, 'http://127.0.0.1:8545'),
      network_id: '*',
      gas: 4500000,
      gasPrice: 20000000000,
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io'),
      network_id: '3',
      gas: 4500000,
      gasPrice: 25000000000,
    },
    rinkeby: {
      provider: new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io'),
      network_id: '4',
      gas: 4500000,
      gasPrice: 25000000000,
    },
    kovan: {
      provider: new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io'),
      network_id: '42',
      gas: 4500000,
      gasPrice: 25000000000,
    },
    mainnet: {
      provider: new HDWalletProvider(mnemonic, 'https://mainnet.infura.io'),
      network_id: '1',
      gas: 4500000,
      gasPrice: 10000000000,
    },
  },
};
