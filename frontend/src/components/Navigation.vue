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
    <v-toolbar app fixed clipped-left color="transparent" flat scroll-off-screen>
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title v-on:click="routeToHome" flat >BCP</v-toolbar-title>
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
      <v-btn v-on:click="routeToAccount" flat class="hidden-md-and-down white--text button">ACCOUNT</v-btn>
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
  }
};
</script>

