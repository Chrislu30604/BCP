import Web3 from 'web3'

/*
* 1. Check for injected web3 (mist/metamask)
* 2. If metamask/mist create a new web3 instance and pass on result
* 3. Get networkId - Now we can check the user is connected to the right network to use our dApp
* 4. Get user account from metamask
* 5. Get user balance
*/

let getWeb3 = new Promise(function (resolve, reject) {
    var web3js = window.Web3
    if (typeof web3js !== 'undefined') {
        console.log("HI")
        var web3 = new Web3(web3js.currentProvider)
        web3.eth.net.isListening().then(_result => {
            resolve({
                injectedWeb3 : _result,
                web3 () {
                    return web3
                }
            })
        })
 
    } else {
        reject(new Error('Unable to connect to Metamask'))
    }
})
    .then(result => {
        return new Promise(function (resolve, reject) {
            result.web3().eth.net.getId((err, networkId) => {
                if (err) {
                    reject(new Error('Unable to retrieve network ID'))
                } else {
                    result = Object.assign({}, result, { networkId })
                    resolve(result)
                }
            })
        })
    })
    .then(result => {
        return new Promise(function (resolve, reject) {
            result.web3().eth.getCoinbase((err, coinbase) => {
                if (err) {
                    reject(new Error('Unable to retrieve coinbase'))
                } else {
                    result = Object.assign({}, result, { coinbase })
                    resolve(result)
                }
            })
        })
    })
    .then(result => {
        return new Promise(function (resolve, reject) {
            // Retrieve balance for coinbase
            result.web3().eth.getBalance(result.coinbase, (err, balance) => {
                if (err) {
                    reject(new Error('Unable to retrieve balance for address: ' + result.coinbase))
                } else {
                    result = Object.assign({}, result, { balance })
                    resolve(result)
                }
            })
        })
    })

export default getWeb3