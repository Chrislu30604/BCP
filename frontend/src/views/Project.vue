<template>
  <v-content id="proj">
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap>
        <div v-for="i in item" :key="i" class="row" >
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">XXX火災受難者</div>
              </div>
            </v-card-title>
            <v-img src="https://cdn.vuetifyjs.com/images/cards/sunshine.jpg" height="300px"></v-img>
            <v-card-text
            >Lorem ipsum dolor sit amet, brute iriure accusata ne mea. Eos suavitate referrentur ad, te duo agam libris qualisque, utroque quaestio accommodare no qui. Et percipit laboramus usu, no invidunt verterem nominati mel. Dolorem ancillae an mei, ut putant invenire splendide mel, ea nec propriae adipisci. Ignota salutandi accusamus in sed, et per malis fuisset, qui id ludus appareat.</v-card-text>
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
        <!--
        <div v-for="i in 4" :key="i" class="row" >
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">XXX火災受難者</div>
              </div>
            </v-card-title>
            <v-img src="https://cdn.vuetifyjs.com/images/cards/sunshine.jpg" height="300px"></v-img>
            <v-card-text
            >Lorem ipsum dolor sit amet, brute iriure accusata ne mea. Eos suavitate referrentur ad, te duo agam libris qualisque, utroque quaestio accommodare no qui. Et percipit laboramus usu, no invidunt verterem nominati mel. Dolorem ancillae an mei, ut putant invenire splendide mel, ea nec propriae adipisci. Ignota salutandi accusamus in sed, et per malis fuisset, qui id ludus appareat.</v-card-text>
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
        -->
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
  beforeMount() {
    const url = "http://127.0.0.1:8081/launch/propose";
    this.axios.get(
      url      
    ).then((response) => {
      console.log(response.data)
      this.item = response.data
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
