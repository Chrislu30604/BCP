<template>
  <v-content id="my-proj">
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap>
        <div v-bind="item" class="row" >
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">{{ item.title }}</div>
              </div>
            </v-card-title>
            <v-img :src="item.imgURL" height="300px"></v-img>
            <v-card-text
            >{{ item.description }}
            </v-card-text>
            <v-progress-linear
              color="cyan"
              height="5"
              value="30"
            ></v-progress-linear>
            <v-card-actions>
              <v-btn flat color="red" v-on:click="closeMission()">Close Mission</v-btn>
            </v-card-actions>
          </v-card>
        </div>
        <div class="row"></div>
        <div class="row"></div>
      </v-layout>
    </v-container>
  </v-content>
</template>



<script>
import * as BCPContract from "../web3/contract/BCPContract"
import * as LIPContract from "../web3/contract/LIPContract"
export default {
  data() {
    return {
      item: {
          title: "",
          description: "",
          imgURL: "",
          minorityURL: "",
          targetFund: "",
      }
    };
  },
  async beforeCreate() {
    // await this.$store.dispatch('registerWeb3') 
    await this.$store.dispatch("getPlatformContractInstance");
    setTimeout(() => {
        this.$store.state.PlatformContractInstance().getMission(
        {
            gas: 3000000,
            from: this.$store.state.web3.coinbase
        },
        (err, result) => {
            if (err) {
                console.log(err);
            } else {
                console.log(result)
                this.item.title = result[1]
                this.item.description = result[2]
                this.item.imgURL = result[3]
                this.item.minorityURL = result[4]
                this.item.targetFund = result[5]
            }
        }
        );
    }, 500);
  },
  methods: {
      closeMission() {
        const BCPAddress = BCPContract.address
        const LIPAddress = LIPContract.address
        this.$store.state.PlatformContractInstance().closeMission(
        BCPAddress,
        LIPAddress,
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
  },
}
</script>


<style lang="scss">
#my-proj {
  .row {
    width: 430px;
    margin-top: 30px;
  }
}
</style>
