import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import getWeb3 from '../web3/getWeb3'
import pollWeb3 from '../web3/pollWeb3'
import getContract from '../web3/pollWeb3'

Vue.use(Vuex)

export const store = new Vuex.Store({
  strict: true,
  state,
  mutations: {
    registerWeb3Instance(state, payload) {
      console.log('registerWeb3Instace Mutation', payload)
      let result = payload
      let web3_state = state.web3
      web3_state.coinbase = result.coinbase
      web3_state.networkId = result.networkId
      web3_state.balance = parseInt(result.balance, 10)
      web3_state.isInjected = result.isInjected
      web3_state.web3Instance = result.web3
      state.web3 = web3_state
      pollWeb3()
    },
    pollWeb3Instance(state, payload) {
      console.log('pollWeb3Instance mutation being executed', payload)
      state.web3.coinbase = payload.coinbase
      state.web3.balance = parseInt(payload.balance, 10)
    },
    registerContractInstance(state, payload) {
      console.log('Exchange account instace:', payload)
      state.contractInstance = () => payload
    }
  },
  actions: {
    registerWeb3 ({commit}) {
      console.log('Register Web3 Action being executed')
      getWeb3.then(result => {
        console.log('register web3 Instance', result)
        commit('registerWeb3Instance', result)
      }).catch(e => {
        console.log('error in action registerWeb3', e)
      })
    },
    pollWeb3({commit}, payload) {
      console.log('pollWeb3 action being executed')
      commit('pollWeb3Instance', payload)
    },
    getContractInstance({commit}) {
      getContract.then(result => {
        commit('registerContractInstance', result)
      }).catch(e => console.log(e))
    }
  }
})
