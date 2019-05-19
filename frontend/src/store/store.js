import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import account from './account'
import getWeb3 from '../web3/getWeb3'
import pollWeb3 from '../web3/pollWeb3'

import getBCPContract from '../web3/getBCPContract'
import getLIPContract from '../web3/getLIPContract'
import getPlatformContract from '../web3/getPlatformContract'

Vue.use(Vuex)
export const store = new Vuex.Store({
  strict: true,
  state,
  account,
  mutations: {
    registerWeb3Instance(state, payload) {
      console.log('registerWeb3Instace Mutation', payload)
      let result = payload
      let web3_state = state.web3
      web3_state.coinbase = result.coinbase
      web3_state.networkId = result.networkId
      web3_state.balance = parseInt(result.balance, 10)
      web3_state.isInjected = result.injectedWeb3
      web3_state.web3Instance = result.web3
      state.web3 = web3_state
      pollWeb3()
    },
    pollWeb3Instance(state, payload) {
      console.log('pollWeb3Instance mutation being executed', payload)
      state.web3.coinbase = payload.coinbase
      state.web3.balance = parseInt(payload.balance, 10)
    },
    registerBCPContractInstance(state, payload) {
      console.log('BCP Instance:', payload)
      state.BCPContractInstance = () => payload
    },
    registerLIPContractInstance(state, payload) {
      console.log('LIP Instance:', payload)
      state.LIPContractInstance = () => payload
    },
    registerPlatformContractInstance(state, payload) {
      console.log('Platform Instance:', payload)
      state.PlatformContractInstance = () => payload
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
    getBCPContractInstance({commit}) {
      getBCPContract().then(result => {
        commit('registerBCPContractInstance', result)
      }).catch(e => console.log(e))
    },
    getLIPContractInstance({commit}) {
      getLIPContract().then(result => {
        commit('registerLIPContractInstance', result)
      }).catch(e => console.log(e))
    },
    getPlatformContractInstance({commit}) {
      getPlatformContract().then(result => {
        commit('registerPlatformContractInstance', result)
      }).catch(e => console.log(e))
    }
  }
})
