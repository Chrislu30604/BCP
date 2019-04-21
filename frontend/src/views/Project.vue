<template>
  <v-content>
    <v-container fluid fill-height grid-list-xl style="maxWidth: 80%;">
      <v-layout justify-space-around row wrap>
        <v-flex v-for="i in 12" :key="i" class="text-xs-center" style="width:26%;" >
          <v-card>
            <v-card-title>
              <div>
                <div class="headline">XXX火災受難者</div>
              </div>
            </v-card-title>
            <v-img src="https://cdn.vuetifyjs.com/images/cards/sunshine.jpg" height="300px"></v-img>
            <v-card-text
              class="px-0"
            >Lorem ipsum dolor sit amet, brute iriure accusata ne mea. Eos suavitate referrentur ad, te duo agam libris qualisque, utroque quaestio accommodare no qui. Et percipit laboramus usu, no invidunt verterem nominati mel. Dolorem ancillae an mei, ut putant invenire splendide mel, ea nec propriae adipisci. Ignota salutandi accusamus in sed, et per malis fuisset, qui id ludus appareat.</v-card-text>
            <v-card-actions>
              <v-btn flat color="cyan">Donate</v-btn>
              <v-btn flat color="orange">Detail</v-btn>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
  </v-content>
</template>

<script>
export default {
  data() {
    return {};
  },

  methods: {}
};
</script>

<style lang="scss">
</style>
