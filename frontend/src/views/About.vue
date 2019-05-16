<template>
  <div id="about">
    <div id="about-word">
      <h2>ABOUT</h2>
      <h2>US</h2>
    </div>
    <div id="about-pic">
      <div id="about-wrap">
        <dm-list-item icon="cloud" icon-size="50px" icon-color="#e1f5fe">Decentralized Tech</dm-list-item>
        <dm-list-item icon="show_chart" icon-size="50px" icon-color="#e1f5fe">Trace History</dm-list-item>
        <dm-list-item icon="public" icon-size="50px" icon-color="#e1f5fe">Donation from all over the world</dm-list-item>
        <dm-list-item icon="cancel" icon-size="50px" icon-color="#e1f5fe">No fake transaction</dm-list-item>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style lang="scss">
$main-color: #00b285;

#about {
  height: 100vh;
  width: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  z-index: -999;

  background: linear-gradient(
    70deg,
    transparent 53%,
    #37474f 40%,
    #37474f 100%,
    transparent 60%
  );
}

#about-word {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: flex-end;
  h2 {
    font-size: 4.2vw;
    font-family: "Roboto Condensed", sans-serif;
  }
}

#about-pic {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;

  .dm-base-list-item .dm-base-list-item__container .dm-base-list-item__circle {
    width: 80px !important;
    height: 80px !important;
    border-width: 6px !important;
    margin-bottom: 12px !important;
  }

  #about-wrap {
    margin-left: 100px;
    > div:nth-child(2) {
      margin-left: 30px;
    }
    > div:nth-child(3) {
      margin-left: 60px;
    }
    > div:nth-child(4) {
      margin-left: 90px;
    }

    p {
      font-size: 24px !important;
    }

  }
}
</style>
