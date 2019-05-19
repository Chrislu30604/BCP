import Web3 from 'web3'
import {address, ABI} from './contract/exchangeContract'

let getExchangeContract = async function () {
    let web3 = await new Web3(window.web3.currentProvider)
    let exchangeContract = await web3.eth.contract(ABI)
    let Contract = exchangeContract.at(address)
    console.log(exchangeContract)
  	console.log(Contract)
    return Contract
}

export default getExchangeContract
