<template>
  <div id="navigation">
    <v-navigation-drawer clipped fixed v-model="drawer" app>
      <v-list dense>
        <v-list-tile>
          <v-list-tile-action>
            <v-icon>dashboard</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Dashboard</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile>
          <v-list-tile-action>
            <v-icon>settings</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Settings</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar app fixed clipped-left flat scroll-off-screen style="background:rgba(0,0,0,0)">
      <v-toolbar-side-icon @click.prevent="drawer = !drawer"></v-toolbar-side-icon>
      <img src="../assets/owl.svg" v-on:click="routeToHome" style="margin-left:30px;width:40px;cursor:pointer">
      <v-toolbar-title v-on:click="routeToHome" flat>Block Charity Point</v-toolbar-title>
      <v-spacer class="hidden-md-and-down"></v-spacer>
      <v-btn flat class="hidden-md-and-down white--text button">ABOUT</v-btn>
      <v-menu transition="slide-y-transition" bottom right>
        <template v-slot:activator="{ on }">
          <v-btn flat dark class="white--text" v-on="on">Project</v-btn>
        </template>

        <v-list>
          <v-list-tile v-for="(item, i) in project" :key="i" v-on:click="item.von">
            <v-list-tile-title>{{ item.title }}</v-list-tile-title>
          </v-list-tile>
        </v-list>
      </v-menu>
      <v-menu transition="slide-y-transition" bottom right>
        <template v-slot:activator="{ on }">
          <v-btn flat dark class="white--text" v-on="on">Account</v-btn>
        </template>

        <v-list>
          <v-list-tile v-for="(item, i) in account" :key="i" v-on:click="item.von">
            <v-list-tile-title>{{ item.title }}</v-list-tile-title>
          </v-list-tile>
        </v-list>
      </v-menu>
    </v-toolbar>
  </div>
</template>

<script>
export default {
  data() {
    return {
      project: [
        { title: "Current project", von: this.routeToProject },
        { title: "Launch project", von: this.routeToLaunch }
      ],
      account: [
        { title: "Login", von: this.routeToLogin },
        { title: "Register", von: this.routeToRegister},
        { title: "Info", von: this.routeToAccount },
      ],
      drawer: false
    };
  },
  methods: {
    routeToHome() {
      this.$router.push("/");
    },
    routeToProject() {
      this.$router.push("/project");
    },
    routeToLaunch() {
      this.$router.push("/launch");
    },
    routeToAccount() {
      this.$router.push("/account")
    },
    routeToLogin() {
      this.$router.push("/login")
    },
    routeToRegister() {
      this.$router.push("/register")
    },
  }
};
</script>

