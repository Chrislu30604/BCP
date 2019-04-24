<template>
  <v-content>
    <v-container fluid fill-height id="account">
      <div id="sidebar">
        <div v-for="item in sideOption" :key="item" class="sidewrap">
           <i class="icon fas fa-user-alt"></i>
           <p>{{ item.title }}</p> 
        </div>
      </div>
      <div id="main"></div>
    </v-container>
  </v-content>
</template>

<script>
export default {
    data() {
        return {
            sideOption: [
                {title: "Overview", icon: "", method: ""},
                {title: "Donation", icon: "", method: ""},
                {title: "Detail", icon: "", method: ""},
                {title: "Exchange", icon: "", method: ""},
            ],
        }
    },


};
</script>


<style lang="scss">
#account {
    width: 90%;
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
}



</style>
