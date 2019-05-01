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
        <div id="content">
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
                    <v-btn style="" color="warning">Submit</v-btn>
                </v-form>
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
        { title: "Overview", icon: "icon fas fa-user-alt", method: "" },
        { title: "History", icon: "icon fas fa-history", method: "" },
        { title: "Detail", icon: "icon fas fa-kiwi-bird", method: "" },
        { title: "Exchange", icon: "icon fas fa-search-dollar", method: "" }
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
      },
    };
  },
  methods: {
    select (event, name) {
      let lastEvent = this.lastClick;
      if (lastEvent == "") {
        lastEvent = event;
      }
      if (event == lastEvent) {

      }
      else {
        lastEvent.target.style.background = "#ff6d00";      
        this.selected = name;
        event.target.style.background = "#ffb74d"; // change new click color
        this.lastClick = event;
      }
    }
  },
};
</script>


<style lang="scss">

.input_text {
    width: 80%;
}

.divider {
    height: 30px;
}

#account {
  width: 70%;
  display: grid;
  grid-template-columns: 10% 80%;
  grid-column-gap: 100px;
}
#sidebar {
  grid-column-start: 1;
  grid-column-end: 2;
  background-color: #424242;
  border-radius: 2%;
  height: 80%;
  /*flexbox*/
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;

  .sidewrap {
    text-align: center;
    width: 100%;
  }

  .icon {
    border-radius: 50%;
    font-size: 40px;
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
}
#main {
  grid-column-start: 2;
  grid-column-end: 3;
  background-color: #424242;
  height: 80%;
  padding: 32px;
  display: grid;
  grid-template-rows: 15% 85%;

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

  #content {
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


}
</style>
