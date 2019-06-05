<template>
  <v-content id="proj">
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap>
        <div v-for="(val, idx) in item" :key="idx" class="row">
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">{{ val.title }}</div>
              </div>
            </v-card-title>
            <v-img :src="val.url" height="300px"></v-img>
            <v-card-text>{{ val.description }}</v-card-text>
            <v-progress-linear color="cyan" height="5" value="30"></v-progress-linear>
            <v-list-tile>
              <v-list-tile-content>
                <v-list-tile-sub-title ><v-icon>pregnant_woman</v-icon> Launcher : {{val.name}}</v-list-tile-sub-title>
                <v-list-tile-sub-title ><v-icon>attach_money</v-icon> Fund: {{val.dollars}}</v-list-tile-sub-title>
              </v-list-tile-content>
              <v-list-tile-content>
                <v-list-tile-sub-title ><v-icon>calendar_today</v-icon> Deadline: {{val.enddate}}</v-list-tile-sub-title>
              </v-list-tile-content>
            </v-list-tile>
            <v-card-actions>
              <!--<v-btn flat color="cyan" v-on:click="donate($event, val)">Donate</v-btn>-->
              <v-dialog v-model="dialog" persistent max-width="400">
                <template v-slot:activator="{ on }">
                  <!-- <v-btn color="primary" dark v-on="on">Open Dialog</v-btn>-->
                  <v-btn flat color="cyan" v-on="on">Donate</v-btn>
                </template>
                <v-card>
                  <v-layout justify-space-around row wrap>
                    <v-card-title class="headline">DONATE Y0UR MONEY</v-card-title>
                    <v-flex xs10>
                    <v-text-field
                      v-model="donateMoney"
                      label="BCP Poiint"
                      prefix="$"
                      color="cyan"
                    ></v-text-field>
                    </v-flex>
                    <v-flex xs10>
                      <v-card-text>Are Your Sure to Donate {{val.title}} ?</v-card-text>
                    </v-flex>
                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn color="red" flat @click="dialog = false">Disagree</v-btn>
                      <v-btn color="green darken-1" flat @click="dialog = false" v-on:click="donate($event,val)">Agree</v-btn>
                    </v-card-actions>
                  </v-layout>
                </v-card>
              </v-dialog>
              <v-btn flat color="orange">Detail</v-btn>
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
import {address} from "../web3/contract/BCPContract"
export default {
  data() {
    return {
      item: [],
      dialog: false,
      donateMoney: "",
    };
  },
  async beforeCreate() {
    const url = "http://127.0.0.1:8081/launch/propose";
    this.axios.get(url).then(response => {
      console.log(response.data);
      this.item = response.data;
    });

    await this.$store.dispatch("web3/getPlatformContractInstance");
  },

  methods: {
    donate(event, res) {
      const BCPAddress = address;
      this.$store.state.PlatformContractInstance().donateMission(
        BCPAddress,
        1,
        parseInt(this.donateMoney,10),
        {
          gas: 3000000,
          from: this.$store.state.web3.coinbase
        },
        (err, result) => {
          if (err) {
            console.log(err);
          } else {
            console.log(result);
          }
        }
      );
    }
  }
};
</script>

<style lang="scss">
#proj {
  .row {
    width: 430px;
    margin-top: 30px;
  }
}
</style>
