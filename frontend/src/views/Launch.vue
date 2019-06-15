<template>
  <v-content>
    <v-container fill-height id="donate">
      <v-layout align-center justify-center>
        <v-flex class="login-form text-xs-center">
          <div class="display-1 mb-3">
            <v-icon class="mr-2" large="large">work</v-icon>Launch Your Donation Project
          </div>
          <v-card>
            <v-card-text>
              <div class="subheading">
                <template>Fill the form</template>
              </div>
              <v-form>
                <v-text-field
                  v-validate="'required|max:20'"
                  data-vv-name="title"
                  :error-messages="errors.collect('title')"
                  v-model="propose.title"
                  prepend-icon="subtitles"
                  label="Enter the Project Title"
                  color="cyan"
                  required
                ></v-text-field>
                <v-text-field
                  v-model="propose.email"
                  v-validate="'required|email'"
                  data-vv-name="email"
                  :error-messages="errors.collect('email')"
                  prepend-icon="email"
                  label="Email"
                  type="email"
                  color="cyan"
                  required
                ></v-text-field>
                <v-text-field
                  v-model="propose.targetFund"
                  v-validate="'between:1,1000000'"
                  data-vv-name="fund"
                  :error-messages="errors.collect('fund')"
                  prepend-icon="attach_money"
                  label="Estimated point"
                  type="text"
                  color="cyan"
                  required
                ></v-text-field>
                <v-menu
                  v-model="menu"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  lazy
                  transition="scale-transition"
                  offset-y
                  full-width
                  min-width="290px"
                >
                  <template v-slot:activator="{ on }">
                    <v-text-field
                      v-model="propose.enddate"
                      slot="activator"
                      label="End time"
                      prepend-icon="date_range"
                      readonly
                      v-on="on"
                      color="cyan"
                      required
                    ></v-text-field>
                  </template>
                  <v-date-picker v-model="propose.enddate" @input="menu = false" :min="today"></v-date-picker>
                </v-menu>
                <v-textarea
                  prepend-icon="description"
                  name="Description"
                  box
                  label="Description"
                  flat
                  v-model="propose.description"
                  color="cyan"
                  required
                ></v-textarea>
                <upload-btn
                  @file-update="update"
                  title="UPLOAD IMAGE"
                  color="blue-grey"
                >
                  <template slot="icon-left">
                    <v-icon left dark>cloud_upload</v-icon>
                  </template>
                </upload-btn>
                <v-btn
                  @click.prevent
                  block="block"
                  @click="submit"
                  color="cyan"
                  class="white--text"
                  type="submit"
                >
                  Submit
                </v-btn>
              </v-form>
            </v-card-text>
          </v-card>
          <div v-if="options.isLoggingIn">
            Don't have an account?
            <v-btn light="light" @click="options.isLoggingIn = false">
              Sign up
              <v-icon right dark>cloud_upload</v-icon>
            </v-btn>
          </div>
        </v-flex>
      </v-layout>
      <v-dialog
        v-model="dialog"
        hide-overlay
        persistent
        width="300"
      >
        <v-card
          color="primary"
          dark
        >
          <v-card-text>
            Wait for The Contract Finish
            <v-progress-linear
              indeterminate
              color="white"
              class="mb-0"
            ></v-progress-linear>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-container>
  </v-content>
</template>

<script>
import UploadButton from 'vuetify-upload-button';
import URL from "../parameter/ip"
import { mapState } from "vuex";
export default {
  data() {
    return {
      propose: {
        title: "",
        name: "",
        email: "",
        targetFund: "",
        currentFund: "0",
        enddate: new Date().toISOString().substr(0, 10),
        description: "",
        url: "",
        file: null,
        missionID: "",
      },
      options: {},
      menu: false,
      today: new Date().toISOString().substr(0, 10),
      web3: null,
      dialog: false,
      contractOK: false,
    };
  },

  async beforeMount() {
    await this.$store.dispatch("web3/getPlatformContractInstance");
  },

  components: {
    'upload-btn': UploadButton
  },
  computed: {
    ...mapState('web3/', {
      PlatformContractInstance: state => state.PlatformContractInstance,
      coinbase: state => state.web3.coinbase,
      web3Instance: state => state.web3.web3Instance,
    }),
  },

  methods: {
    submitToSmartContract(obj) {
      return new Promise((resolve, reject) => {
        this.PlatformContractInstance().addMission(
          obj.title,
          obj.description,
          obj.url,
          obj.url,
          parseInt(obj.targetFund, 10),
          {
            gas: 3000000,
            from: this.coinbase
          },
          async (err, result) => {
            if (err) {
              console.log(err);
              reject(err)
            } else {
              console.log(result)
              let web3 = await new Web3(window.web3.currentProvider)
              this.dialog = true
              var timer = setInterval(async () => {
                await web3.eth.getTransactionReceipt(result, async (err, receipt) => {
                  if(receipt !== null) {
                    console.log(receipt.status)
                    if (receipt.status == "0x1") {
                      console.log("Close dialog")
                      clearInterval(timer)
                      const MissionID = await this.getMission()
                      this.dialog = false
                      this.contractOK = true
                      resolve(MissionID)    
                    }
                  }
                })
              }, 500);
            }
          }
        );
      })
    },

    getMission() {
      return new Promise((resolve, reject) => {
        this.PlatformContractInstance().getMission(
          {
            gas: 3000000,
            from: this.coinbase
          },
          async (err, result) => {
            if (err) {
              console.log(err);
              reject(err)
            } else {
              console.log("Mission 1D = ", result[0].c[0])
              
              resolve(result[0].c[0])
            }
          }
        )
      })
    },

    submit() {
      this.$validator.validateAll().then(async (valid) => {
        if (valid) {

          let form = new FormData()
          form.append('image', this.propose.file)
          // 1. Post image to IMGUR
          const imgURL =  "https://api.imgur.com/3/image"
          const clientID = "8c2fff697c335bc"
          let config = {
            headers: {
              'Authorization': 'Client-ID ' + clientID,
          }}
          await this.axios.post(imgURL, 
            form,
            config
          )
          .then((response) => {
            console.log(response.data.data.link)
            this.propose.url = response.data.data.link
          })
          .catch((error) => {
            console.log(error)
          })
          
          // 3. Send to Contract
          console.log("3. Send to Contract")
          this.propose.name = this.$store.getters['account/user'].name
          const obj = this.propose
          const missionID = await this.submitToSmartContract(obj);

          if (this.contractOK == true) {
            // 4. Post Information to Backend
            console.log("4. Post MissionID to backend")
            this.propose.missionID = missionID
            const backendObj = this.propose
            const url = URL.launch.propose
            let configs = { headers: {
              'accept': 'application/json',
              'Accept-Language': 'en-US,en;q=0.8',
              'Content-Type': 'multipart/form-data'}};

            // Send to backend
            await this.axios
              .post(url,
                    backendObj,
                    configs)
              .then((response) => {
                console.log(response)
                /* Send to Smart Contract */
                setTimeout(() => {
                  this.$router.push('/project')
                }, 1000);
              })
              .catch((error) => {
                console.log(error)
              })
            }
        }
      });
    },
    update(file) {
      this.propose.file = file
    },
  }
};
</script>

<style lang="scss">
#donate {
  width: 40%;
}
#upload {
  height: 0;
  width: 0;
  visibility: hidden;
}
</style>
