<template>
  <v-content>
    <v-container fluid fill-height id="account">
      <div id="sidebar">
        <div v-for="(item, idx) in sideOption" :key="idx" class="sidewrap">
          <i :class="item.icon" v-on:click="select($event, item.title)"></i>
          <p>{{ item.title }}</p>
        </div>
      </div>
      <div id="main">
        <div id="header">
          <avatar class="avatar" username="Jane Doewd" :size="64"></avatar>
          <div>
            <h2>Jane Dowdewq</h2>
            <span>Member since Aug 09, 2018</span>
          </div>
        </div>
        <div id="overview" v-if="selected == 'Overview'">
          <div id="email-passw">
            <h2>EMAILS</h2>
            <v-form>
              <v-text-field
                v-validate="'required|max:20'"
                data-vv-name="email"
                :error-messages="errors.collect('email')"
                v-model="user.email"
                prepend-icon="email"
                color="cyan"
                class="input_text"
                required
              ></v-text-field>
              <v-text-field
                v-validate="'required|max:20'"
                data-vv-name="new_email"
                :error-messages="errors.collect('new_email')"
                v-model="user.new_email"
                placeholder="Enter your another email"
                prepend-icon="email"
                color="cyan"
                class="input_text"
                required
              ></v-text-field>
              <div class="divider"></div>
            </v-form>
            <h2>PASSWORD</h2>
            <v-form>
              <v-text-field
                v-model="user.password"
                v-validate="'required|min:6'"
                data-vv-name="password"
                :error-messages="errors.collect('password')"
                color="cyan"
                prepend-icon="lock"
                placeholder="Enter your current password"
                type="password"
                class="input_text"
              ></v-text-field>
              <v-text-field
                v-model="user.new_password"
                v-validate="'required|min:6'"
                data-vv-name="new_password"
                :error-messages="errors.collect('new_password')"
                color="cyan"
                prepend-icon="lock"
                placeholder="Enter your new password"
                type="password"
                class="input_text"
                ref="passwd"
              ></v-text-field>
              <v-text-field
                v-model="user.match_password"
                v-validate="'required|confirmed:passwd'"
                data-vv-name="match_password"
                :error-messages="errors.collect('match_password')"
                color="cyan"
                prepend-icon="lock"
                placeholder="Retype your new password"
                type="password"
                class="input_text"
              ></v-text-field>
            </v-form>
          </div>
          <div id="information">
            <h2>ACCOUNT INFORMATION</h2>
            <v-form>
              <v-text-field
                v-model="user.username"
                v-validate="'required|max:20|alpha_spaces'"
                :counter="20"
                data-vv-name="username"
                :error-messages="errors.collect('username')"
                color="cyan"
                prepend-icon="account_circle"
                placeholder="Full Name"
                class="input_text"
              ></v-text-field>
              <v-text-field
                v-model="user.company"
                v-validate="'required|alpha_space'"
                data-vv-name="company"
                :error-messages="errors.collect('company')"
                color="cyan"
                prepend-icon="home"
                placeholder="Company"
                class="input_text"
              ></v-text-field>
              <v-text-field
                v-model="user.phone"
                v-validate="'required|numeric'"
                data-vv-name="phone"
                :error-messages="errors.collect('phone')"
                color="cyan"
                prepend-icon="phone_in_talk"
                placeholder="Phone"
                class="input_text"
              ></v-text-field>
              <v-text-field
                v-model="user.profile_url"
                v-validate="'required'"
                data-vv-name="profile_url"
                :error-messages="errors.collect('profile_url')"
                color="cyan"
                prepend-icon="whatshot"
                placeholder="Profile Url"
                class="input_text"
              ></v-text-field>
              <div class="divider"></div>
              <v-btn style color="warning">Submit</v-btn>
            </v-form>
          </div>
        </div>
        <div id="exchange" v-else-if="selected == 'Exchange'">
          <h2 id="currency_header">YOUR CURRENCY</h2>
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
            </v-layout>
          </div>
          <div id="Bcurrency">
            <v-layout row>
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
            <v-btn @click="submit_exchange" color="warning">Submit</v-btn>
          </div>
        </div>
      </div>
    </v-container>
  </v-content>
</template>

<script>
import Avatar from "vue-avatar";

export default {
  components: {
    Avatar
  },
  data() {
    return {
      selected: "Overview",
      lastClick: "",
      sideOption: [
        { title: "Overview", icon: "first-selected icon fas fa-user-alt" },
        { title: "History", icon: "icon fas fa-history" },
        { title: "Detail", icon: "icon fas fa-kiwi-bird" },
        { title: "Exchange", icon: "icon fas fa-search-dollar" }
      ],
      user: {
        email: "chrislu30604@gmail.com",
        new_email: "",
        password: "",
        new_password: "",
        match_password: "",
        username: "",
        company: "",
        phone: "",
        profile_url: "",
        linepoint: 40,
        bcppoint: 3000,
        ex_linepoint: 0,
      }
    };
  },
  methods: {
    select(event, name) {
      let lastEvent = this.lastClick;
      if (lastEvent == "") {
        document.getElementsByClassName("first-selected")[0].style.background =
          "#37efba";
        lastEvent = event;
      }
      lastEvent.target.style.background = "#37efba";
      this.selected = name;
      event.target.style.background = "#ffb74d"; // change new click color
      this.lastClick = event;
    },
    submit_exchange() {
      this.$validator.validateAll().then((result) => {
        // console.log(this.user.ex_linepoint);
      })
    }
  },
  computed: {
    exCurrency: {
      get() {
        return this.user.ex_linepoint * 2;
      }
    },
    displayCurrency: {
      get() {
        return this.user.ex_linepoint || ''
      },
      set(value) {
        this.user.ex_linepoint = value; 
      },
    },
  },
};
</script>


<style lang="scss">
.input_text {
  width: 80%;
}
.ex_text {
  width: 60%;
}

.divider {
  height: 30px;
}

#account {
  width: 70%;
  display: grid;
  grid-template-columns: 120px 900px;
  grid-column-gap: 100px;
}
#sidebar {
  grid-column-start: 1;
  grid-column-end: 2;
  background-color: #424242;
  height: 80%;
  /*flexbox*/
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;

  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  transition: all 0.3s cubic-bezier(.25,.8,.25,1);
  .sidewrap {
    text-align: center;
    width: 100%;
  }

  .icon {
    cursor: pointer;
    border-radius: 50%;
    font-size: 3em;
    padding: 12px;
    vertical-align: middle;
    color: white;
    background-color: #37efba;
    margin-bottom: 5px;
    -webkit-transition: all 0.3s ease-in-out;
    -moz-transition: all 0.3s ease-in-out;
    -ms-transition: all 0.3s ease-in-out;
    -o-transition: all 0.3s ease-in-out;
    transition: all 0.3s ease-in-out;

    &:hover,
    &:active {
      -webkit-transform: scale(1.1) rotate(360deg);
      -moz-transform: scale(1.1) rotate(360deg);
      -ms-transform: scale(1.1) rotate(360deg);
      -o-transform: scale(1.1) rotate(360deg);
      transform: scale(1.1) rotate(360deg);
    }
  }
  .first-selected {
    background-color: #ffb74d;
  }
}
#main {
  grid-column-start: 2;
  grid-column-end: 3;
  background-color: #424242;
  height: 80%;
  padding: 32px;
  display: grid;
  grid-template-rows: 15% 85%;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  transition: all 0.3s cubic-bezier(.25,.8,.25,1);

  #header {
    grid-row-start: 1;
    grid-row-end: 2;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    border-bottom: 1px solid #b9b7b7;
    .avatar {
      margin-right: 20px;
    }
  }

  #overview {
    display: grid;
    grid-template-columns: 1fr 1fr;
    h2 {
      color: #cfcfcf;
      font-weight: 500;
    }
    #email-passw {
      padding: 30px;
    }
    #information {
      padding: 30px;
    }
  }

  #exchange {
    display: grid;
    grid-template-rows: 10% 15% 10% 50% 15%;
    grid-template-columns: 1fr 1fr;

    h2 {
      color: #cfcfcf;
      font-weight: 500;
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
      padding: 30px;
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
      justify-content: center;
    }
  }
}
</style>
