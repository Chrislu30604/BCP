<template>
  <div style="display:flex; flex-direction:column; align-item:center; justify-conter:center">
    <v-form style="margin-bottom:30px;width:320px;" v-if="isInjected">
      <v-text-field
        v-model="register.network"
        v-validate="'required'"
        data-vv-name="network"
        :error-messages="errors.collect('network')"
        prepend-icon="network_wifi"
        label="MetaMask Network"
        :placeholder="network"
        type="text"
        color="cyan"
        class="input"
        required
      ></v-text-field>
      <v-text-field
        v-model="register.coinbase"
        v-validate="'required|alpha_num'"
        data-vv-name="coinbase"
        :error-messages="errors.collect('coinbase')"
        prepend-icon="android"
        label="MetaMask Account"
        :placeholder="coinbase"
        type="text"
        color="cyan"
        class="input"
        required
      ></v-text-field>
      <p>You will receive <font color="cyan">500 LIP</font> at first time</p>
    </v-form>
    <div v-if="!isInjected" style="display:flex; justify-content:center">
      <p id="error_message">You Need to Login Metamask</p>
    </div>
    <div style="display:flex; justify-content:center">
      <p id="error_display"></p>
    </div>
    <v-btn v-if="isInjected" color="info" depressed @click="submit">Confirm</v-btn>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { Networks } from "../web3/networks";
import * as LIPContract from "../web3/contract/LIPContract"
import URL from "../parameter/ip"
export default {
  name: "RegisterMetamask",
  data() {
    return {
      register: {
        coinbase: "",
        network: "",
      }
    };
  },

  async beforeMount() {
      if (this.isInjected) {
        await this.$store.dispatch("web3/getLIPContractInstance")
      }
  },

  methods: {
    submit() {
      this.$validator.validateAll().then(valid => {
        if(valid) {
          // First, we should check the metaMask address is only one?
          const url = URL.register.queryMetamask;
          let obj = this.register;
          this.axios
            .post(url, obj)
            .then(async (response) => {
              if (response.data.status === "OK") {
                // if OK distribute linepoint to it
                await this.distributeLIP()              
                this.$emit('triggerSuccess', obj)
              } else {
                const error_message = response.data.status
                document.getElementById('error_display').innerHTML = response.data.status
              }
            })
            .catch(error => {
              console.log(error);
            });
        }
      });
    },
    distributeLIP() {
        return new Promise((resolve, reject) => {
            console.log("Distribute LIP")
            let LIPAddress = LIPContract.address
            this.LIPContractInstance().distributePoints(
            this.coinbase,
            500,
            {
                gas: 3000000,
                from: this.coinbase
            },
            (err, result) => {
                if (err) {
                    console.log(err);
                    reject(err)
                } else {
                    console.log(result)
                    resolve(result)
                }
            }
            );
        })
    }
  },

  mounted() {
      this.register.coinbase = this.coinbase
      this.register.network = this.network
  },

  computed: {
    ...mapState('web3/',{
      isInjected: state => state.web3.isInjected,
      network: state => Networks[state.web3.networkId],
      coinbase: state => state.web3.coinbase,
      balance: state => state.web3.balance,
      web3Instance: state => state.web3.web3Instance,
      LIPContractInstance: state => state.LIPContractInstance,
    })
  },
};
</script>

<style lang="scss">
#error_message, #error_display{
  color: #FD5151;
  font-size: 1.2em;
  margin-top: 20px;
}
</style>