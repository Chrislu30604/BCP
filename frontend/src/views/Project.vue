<template>
  <v-content id="proj">
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap>
        <div v-for="(val, idx) in item" :key="idx" class="row" >
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">{{ val.title }}</div>
              </div>
            </v-card-title>
            <v-img :src="val.url" height="300px"></v-img>
            <v-card-text
            >{{ val.description }}</v-card-text>
            <v-progress-linear
              color="cyan"
              height="5"
              value="30"
            ></v-progress-linear>
            <v-card-actions>
              <v-btn flat color="cyan">Donate</v-btn>
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
export default {
  data() {
    return {
      item: []


    };
  },
  beforeCreate() {
    const url = "http://127.0.0.1:8081/launch/propose";
    this.axios.get(
      url      
    ).then((response) => {
      console.log(response.data)
      this.item = response.data
      console.log(this.item[0].title)
    })
  },

  methods: {}
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
