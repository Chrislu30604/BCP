import Web3 from 'web3'
import {address, ABI} from './contract/pointContract'

let getContract = new Promise(function (resolve, regject) {
    let web3 = new Web3(window.web3.currentProvider)
    let pointContract = web3.eth.Contract(ABI)
    let pointContractInstance = pointContract.at(address)
    console.log(pointContract)
    console.log(pointContractInstance)
})

export default getContract