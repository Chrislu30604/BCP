<template>
  <div style="height:100%">
    <div v-if="!isSubmit" id="exchange">
      <h2 id="currency_header">YOUR CURRENCY & ACCOUNT</h2>
      <div id="Lcurrency">
        <v-layout row>
          <v-flex xs6>
            <v-subheader>Line Point</v-subheader>
          </v-flex>
          <v-flex xs10>
            <v-text-field
              label="Amount"
              :value="user.linepoint"
              prefix="$"
              color="cyan"
              readonly
              class="input_text"
            ></v-text-field>
          </v-flex>
          <v-flex xs6>
            <v-subheader>BCP Point</v-subheader>
          </v-flex>
          <v-flex xs10>
            <v-text-field
              label="Amount"
              :value="user.bcppoint"
              prefix="$"
              readonly
              color="cyan"
              class="input_text"
            ></v-text-field>
          </v-flex>
        </v-layout>
      </div>
      <div id="Bcurrency">
        <div class="metamask-info">
          <p v-if="isInjected" id="has-metamask">
            <i aria-hidden="true" class="fa fa-check"></i> Metamask installed
          </p>
          <p v-else id="no-metamask">
            <i aria-hidden="true" class="fa fa-times"></i> Metamask not found
          </p>
          <p>Network: {{ network }}</p>
          <p>Account: {{ coinbase }}</p>
          <p>Balance: {{ ethBalance }} Wei</p>
        </div>
      </div>
      <h2 id="exchange_header">EXCHANGE CURRENCY</h2>
      <div id="linepoint">
        <img class="point" src="../assets/line.svg">
        <v-text-field
          v-model="displayCurrency"
          v-validate="'required|numeric|max_value:' + user.linepoint"
          data-vv-name="point"
          :error-messages="errors.collect('point')"
          label="Line point"
          prefix="$"
          placeholder="enter your point"
          color="cyan"
          class="ex_text"
        ></v-text-field>
      </div>
      <div id="bcppoint">
        <img class="point" src="../assets/money-bag.svg">
        <v-text-field
          v-model="exCurrency"
          label="BCP point"
          prefix="$"
          color="cyan"
          readonly
          class="ex_text"
        ></v-text-field>
      </div>
      <div id="btn_submit">
        <v-btn @click="submit" color="warning">Submit</v-btn>
      </div>
    </div>
    <div v-else id="exchange_OK">
      <h1>You are Successfully exchange point!!</h1>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { Networks } from "../web3/networks";
export default {
  data() {
    return {
      user: {
        linepoint: null,
        bcppoint: null,
        ex_linepoint: 0
      },
      isSubmit: false,
    };
  },

  async beforeMount() {
    console.log("submit exchange");
    await this.$store.dispatch("getBCPContractInstance");
    await this.$store.dispatch("getLIPContractInstance")
    setTimeout(() => {
      this.$store.state.BCPContractInstance().balanceOf(
        this.$store.state.web3.coinbase,
        {
          gas: 3000000,
          from: this.$store.state.web3.coinbase
        },
        (err, result) => {
          if (err) {
            console.log(err);
          } else {
            this.user.bcppoint = result.c[0];
          }
        }
      );
      this.$store.state.LIPContractInstance().balanceOf(
        this.$store.state.web3.coinbase,
        {
          gas: 3000000,
          from: this.$store.state.web3.coinbase
        },
        (err, result) => {
          if (err) {
            console.log(err);
          } else {
            this.user.linepoint = result.c[0];
          }
        }
      );
    }, 500);
  },
  methods: {
    submit() {
      this.$validator.validateAll().then(valid => {
        if (valid) {
          console.log("submit");
          this.isSubmit = true
          let LIPAddress = "0x699D3BAA37c46aE9A3A83d0Cc43161651F0f7083"
          console.log(this.user.ex_linepoint)
          this.$store.state.BCPContractInstance().LIPtoBCP(
            LIPAddress,
            this.user.ex_linepoint,
            {
              gas: 3000000,
              from: this.$store.state.web3.coinbase
            },
            (err, result) => {
              if (err) {
                console.log(err);
              } else {
                console.log(result)
              }
            }
          );
        }
      });
    }
  },
  computed: {
    ...mapState({
      isInjected: state => state.web3.isInjected,
      network: state => Networks[state.web3.networkId],
      coinbase: state => state.web3.coinbase,
      balance: state => state.web3.balance,
      ethBalance: state => {
        if (state.web3.web3Instance !== null)
          return state.web3.web3Instance().fromWei(state.web3.balance, "ether");
      }
    }),

    exCurrency: {
      get() {
        return this.user.ex_linepoint * 2;
      }
    },
    displayCurrency: {
      get() {
        return this.user.ex_linepoint || "";
      },
      set(value) {
        this.user.ex_linepoint = value;
      }
    }
  }
};
</script>


<style lang="scss">
#exchange_OK {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  h1 {
    color: #5fd89c;
    size: 28px;
  }

}
#exchange {
  display: grid; //  10% 15% 10% 50% 15%
  grid-template-rows: 60px 90px 60px 200px auto;
  grid-template-columns: 1fr 1fr;

  h2 {
    color: #cfcfcf;
    font-weight: 500;
  }

  .metamask-info {
    p {
      line-height: 10px;
    }
  }
  #currency_header {
    grid-row-start: 1;
    grid-row-end: 2;
    grid-column-start: 1;
    grid-column-end: 3;
    padding: 30px;
  }
  #exchange_header {
    grid-row-start: 3;
    grid-row-end: 4;
    grid-column-start: 1;
    grid-column-end: 3;
    padding: 30px;
  }
  #Lcurrency {
    grid-row-start: 2;
    grid-row-end: 3;
    grid-column-start: 1;
    grid-column-end: 2;
    padding: 30px;
  }
  #Bcurrency {
    grid-row-start: 2;
    grid-row-end: 3;
    grid-column-start: 2;
    grid-column-end: 3;
  }
  #linepoint {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 30px;
  }
  #bcppoint {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 30px;
  }
  .point {
    display: block;
    width: 84px;
  }
  #btn_submit {
    grid-column-start: 1;
    grid-column-end: 3;
    display: flex;
    justify-content: space-around;
    align-items: flex-start;
  }
  #has-metamask {
    color: green;
  }
  #no-metamask {
    color: red;
  }
}
</style>
