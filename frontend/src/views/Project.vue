<template>
  <v-content id="proj">
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap v-if="item.length">
        <div v-for="(val, idx) in item" :key="idx" class="row">
          <v-dialog v-model="dialog" persistent max-width="400">
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
                  <v-card-text>Are Your Sure to Donate {{modal.title}} ?</v-card-text>
                </v-flex>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="red" flat v-on:click="disableDialog">Disagree</v-btn>
                  <v-btn color="green darken-1" flat v-on:click="donate($event, modal)">Agree</v-btn>
                </v-card-actions>
              </v-layout>
            </v-card>
          </v-dialog>
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">{{ val.title }}</div>
              </div>
            </v-card-title>
            <v-img :src="val.url" height="300px"></v-img>
            <v-card-text>{{ val.description }}</v-card-text>
            <v-progress-linear color="cyan" height="5" :value="progress(val.currentFund, val.targetFund)"></v-progress-linear>
            <v-list-tile>
              <v-list-tile-content>
                <v-list-tile-sub-title ><v-icon>pregnant_woman</v-icon> Launcher : {{val.name}}</v-list-tile-sub-title>
                <v-list-tile-sub-title ><v-icon>attach_money</v-icon> Target Fund: {{val.targetFund}}</v-list-tile-sub-title>
              </v-list-tile-content>
              <v-list-tile-content>
                <v-list-tile-sub-title ><v-icon>update</v-icon> Deadline: {{val.enddate}}</v-list-tile-sub-title>
                <v-list-tile-sub-title ><v-icon>attach_money</v-icon> Current Fund: {{val.currentFund}}</v-list-tile-sub-title>
              </v-list-tile-content>
            </v-list-tile>
            <v-card-actions>
              <!--<v-btn flat color="cyan" v-on:click="donate($event, val)">Donate</v-btn>-->
              <v-btn flat color="cyan" v-on:click="showModal($event, val, idx)">Donate</v-btn>
              <v-btn flat color="orange">Detail</v-btn>
            </v-card-actions>
          </v-card>
        </div>
        <div class="row"></div>
        <div class="row"></div>
      </v-layout>
      <v-layout justify-space-around align-center wrap v-else>
        <h1>No Current Project Found</h1>
      </v-layout>
    </v-container>
  </v-content>
</template>

<script>
import {address} from "../web3/contract/BCPContract"
import URL from "../parameter/ip"
import { mapState } from "vuex";
export default {
  data() {
    return {
      item: [],
      dialog: false,
      donateMoney: "",
      modal: "",
      idx: 0,
    };
  },
  async beforeCreate() {
    const url = URL.launch.propose
    this.axios.get(url).then(response => {
      console.log(response.data);
      this.item = response.data;
    });

    await this.$store.dispatch("web3/getPlatformContractInstance");
  },

  computed: {
    ...mapState('web3/', {
      PlatformContractInstance: state => state.PlatformContractInstance,
      coinbase: state => state.web3.coinbase,
    }),
  },
  methods: {
    progress(currentFund, targetFund) {
      return parseInt(currentFund) / parseInt(targetFund) * 100
    },

    showModal(event, res, idx) {
      console.log(res.title)
      this.modal = res
      this.idx = idx + 1
      this.dialog = true;
    },

    disableDialog(event, res) {
      event.preventDefault()
      this.dialog = false
    },

    donate(event, res) {
      event.preventDefault()
      this.dialog = false
      const BCPAddress = address;
      console.log("missionId is :", this.idx)
      this.PlatformContractInstance().donateMission(
        BCPAddress,
        this.idx,
        parseInt(this.donateMoney, 10),
        {
          gas: 3000000,
          from: this.coinbase
        },
        (err, result) => {
          if (err) {
            console.log(err);
          } else {
            console.log(result);
            this.changeProjectInfo(this.donateMoney, res)
          }
        }
      );
    },

    changeProjectInfo(donateMoney, res) {
      res.currentFund = (parseInt(res.currentFund) + parseInt(donateMoney)).toString()
      const url = URL.launch.update
      console.log(res)
      this.axios.post(url, res)
      .then((response) => {
        console.log(response)
      })
      .catch((error) => {
        console.log(error)
      })
    },
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
