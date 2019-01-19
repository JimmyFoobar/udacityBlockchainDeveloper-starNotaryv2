// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    ganache: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    },
    rinkeby: {
      provider: function() {
     return new HDWalletProvider("mnemonic", "https://rinkeby.infura.io/api")
         },
          network_id: '4',
          gas: 4500000,
          gasPrice: 10000000000,
        }
  }
}
