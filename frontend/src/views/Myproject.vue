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
        this.$store.state.PlatformContractInstance().closeMission(
        "0x46d05BAcBA343e2236041b48453980e196c9e321",
        "0xd5C5C64f6D62C3fb0434d4BB80E5BD11cc3fd509",
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
