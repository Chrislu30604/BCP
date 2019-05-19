let state = {
    web3: {
        isInjected: false,
        web3Instance: null,
        networkId: null,
        coinbase: null,
        balance: null,
        error: null
    },
    BCPContractInstance: null,
    LIPContractInstance: null,
    PlatformContractInstance: null,
}
export default state