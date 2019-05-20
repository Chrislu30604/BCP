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
            <v-img src="https://i.imgur.com/mpcjHrA.jpg" height="300px"></v-img>
            <v-card-text
            >{{ item.description }}</v-card-text>
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
    await this.$store.dispatch('registerWeb3') 
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
        const BCPAddress = "0xDEcF01E2DCfDA51d64271546ee7150F956A1128B"
        const LIPAddress = "0x699D3BAA37c46aE9A3A83d0Cc43161651F0f7083"
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

</style>
