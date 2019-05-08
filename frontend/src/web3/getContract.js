import Web3 from 'web3'
import {address, ABI} from './contract/pointContract'

let getContract = function () {
    return new Promise(function (resolve) {
        let web3 = new Web3(window.web3.currentProvider)
        let pointContract = web3.eth.Contract(ABI)
        resolve(pointContract)
        console.log(pointContract)
    })
}

export default getContract