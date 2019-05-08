import Web3 from 'web3'

let web3Obj = {
    web3Provider: null,
    contracts: {},
    web3_state: {
        isInjected: false,
        web3Instance: null,
        networkId: null,
        coinbase: null,
        balance: null,
        error: null
    },

    initWeb3: async function () {
        // Modern dapp browsers...
        if (window.ethereum) {
            web3Obj.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
                web3Obj.web3_state.isInjected = true;
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            web3Obj.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            web3Obj.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }
        let web3 = new Web3(web3Obj.web3Provider);
        await web3Obj.getNetworkAndBalance(web3);
        return web3Obj.web3_state;
    },
    
    getNetworkAndBalance: async function (web3) {
        web3Obj.web3_state.networkId = await web3.eth.getId()
        web3Obj.web3_state.coinbase = await web3.eth.getCoinbase()
        web3Obj.web3_state.balance = await web3.eth.getBalance(web3Obj.web3_state.coinbase)
    },
}

export default web3Obj