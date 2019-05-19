import Web3 from 'web3'
import {address, ABI} from './contract/BCPContract'

let getBCPContract = async function () {
    let web3 = await new Web3(window.web3.currentProvider)
    let BCPContract = await web3.eth.contract(ABI)
    let Contract = BCPContract.at(address)
    console.log(BCPContract)
  	console.log(Contract)
    return Contract
}

export default getBCPContract
