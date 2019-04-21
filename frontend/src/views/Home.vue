<template>
  <div id="intro">
    <div id="title">
      <h1>{{ bigtitle }}</h1>
      <h2>{{ subtitle }}</h2>
    </div>
    <div id="side-intro1">
    </div>
    <div id="side-intro2">
    </div>
  </div>
</template>

<script>

  export default {
    data() {
      return {
        bigtitle: "DECENTRALIZED COUPON CHARITY PLATFORM",
        subtitle: "IT'S TIME TO DONATE YOUR NEEDLESS POINTS TO EXCHANGE WHAT YOU NEED AND HELP OTHERS",
      }
    },

  }
</script>

<style lang="scss">
@import url(https://fonts.googleapis.com/css?family=Roboto+Condensed);

@mixin flex-box($jc: center, $ai: center) {
  display: flex;
  justify-content: $jc;
  align-items: $ai;
}

#intro {
  position: relative;
  top: 64px;
  height: calc(100% - 64px);
  width: 100%;
  display: grid;
  grid-template-rows: 1fr 1fr;
  grid-template-columns: 1fr 1.2fr;

  #title {
    grid-row-start: 1;
    grid-row-end: 2;
    grid-column-start: 1;
    grid-column-end: 3;
    @include flex-box();
    flex-direction: column;

    h1 {
      font-size: 4em;
      font-family: 'Roboto Condensed';
    }
    h2 {
      font-size: 2em;
    }
  }

  #side-intro1 {
    grid-row-start: 2;
    grid-row-end: 3;
    grid-column-start: 1;
    grid-column-end: 2;
  }

  #side-intro2 {
    grid-row-start: 2;
    grid-row-end: 3;
    grid-column-start: 2;
    grid-column-end: 3;
  }
}

</style>
