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
                  v-model="user.title"
                  prepend-icon="subtitles"
                  label="Enter the Project Title"
                  color="cyan"
                  required
                ></v-text-field>
                <v-text-field
                  v-validate="'required|max:20'"
                  data-vv-name="name"
                  :error-messages="errors.collect('name')"
                  v-model="user.name"
                  prepend-icon="person"
                  label="Beneficiary and Sponsor"
                  color="cyan"
                  required
                ></v-text-field>
                <v-text-field
                  v-model="user.email"
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
                  v-model="user.dollars"
                  v-validate="'between:1,1000000'"
                  data-vv-name="dollars"
                  :error-messages="errors.collect('dollars')"
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
                      v-model="user.enddate"
                      slot="activator"
                      label="End time"
                      prepend-icon="date_range"
                      readonly
                      v-on="on"
                      color="cyan"
                      required
                    ></v-text-field>
                  </template>
                  <v-date-picker v-model="user.date" @input="menu = false" :min="today"></v-date-picker>
                </v-menu>
                <v-textarea
                  prepend-icon="description"
                  name="Description"
                  box
                  label="Description"
                  flat
                  v-model="user.description"
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
    </v-container>
  </v-content>
</template>

<script>
import UploadButton from 'vuetify-upload-button';
export default {
  data() {
    return {
      user: {
        title: "",
        name: "",
        email: "",
        dollars: "",
        enddate: new Date().toISOString().substr(0, 10),
        description: "",
        file: null,
        url: "",
      },
      options: {},
      menu: false,
      today: new Date().toISOString().substr(0, 10)
    };
  },

  async beforeMount() {
    await this.$store.dispatch('registerWeb3') 
    await this.$store.dispatch("getPlatformContractInstance");
  },

  components: {
    'upload-btn': UploadButton
  },

  methods: {
    submitToSmartContract() {
      this.$store.state.PlatformContractInstance().addMission(
        "HI",
        "HI description",
        "https",
        "https",
        1000,
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
      // value: this.$store.state.web3.web3Instance().toWei(0.00001, 'ether'),
    },

    submit() {
      this.$validator.validateAll().then(async (valid) => {
        if (valid) {

          /*   Send to Backend */
          let form = new FormData()
          form.append('image', this.user.file)
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
            this.user.url = response.data.data.link
          })
          .catch((error) => {
            console.log(error)
          })

          // 2. Post Information to Backend

          const url = "http://127.0.0.1:8081/launch/propose";
          const obj = this.user
          let configs = { headers: {
            'accept': 'application/json',
            'Accept-Language': 'en-US,en;q=0.8',
            'Content-Type': 'multipart/form-data'}};
          let Postform = new FormData()
          Postform.append("title", obj.title)
          Postform.append("name", obj.name)
          Postform.append("email", obj.email)
          Postform.append("dollars", obj.dollars)
          Postform.append("enddate", obj.enddate)
          Postform.append("description", obj.description)
          Postform.append("url", obj.url)

          await this.axios
            .post(url,
                  Postform,
                  configs)
            .then((response) => {
              console.log(response)
            })
            .catch((error) => {
              console.log(error)
            })

          /* Send to Smart Contract */
          this.submitToSmartContract(obj);
        }
      });
    },
    update(file) {
      this.user.file = file
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
