<template>
  <div class="telemetry">
    <md-card class="card-telemetry">
        <md-card-header>
        <div class="md-title">User Behavior</div>
      </md-card-header>
      <md-card-content>
        <template v-if="information.length">
        <template v-for="(info, i) in information">
          <div :key="i">
            <label>{{screenName(info.currentScreen)[0].name}}</label>
            <br>
            <label>User clicked on:</label>
            <div class="box">
              <div class="dot" 
                :style="`top: ${info.positionY * 100}%; left: ${info.positionX * 100}%`"
                ></div>
            </div>
            <md-divider class="seperate"></md-divider>
          </div>
          </template>
        </template>
        <img src="../assets/Series 4 - 40mm - Space Gray Copy 3@2x.png"/>
      </md-card-content>
    </md-card>
  </div>  
</template>

<script>
import API from '../service';

export default {
  name: "Telemetry",
  props: {
    screens: {
      type: Array,
    }
  },
  data() {
    return {
      information: [],

    }
  }, 

  watch: {
    screens() {
      this.getTelemtry();
    }
  },

  methods: {
    async getTelemtry() {
      this.information = await API.getTelemetry(this.$route.params.id);
    },
    screenName(uuid) {
      return this.screens.filter(i => (i.uuid === uuid));
    },
    calcDirection(info) {
      console.log('info', info);
      const parent = this.screens.filter(i => (i.uuid === info.currentScreen));
      console.log('parent', parent);
    }
  },
}
</script>

<style lang="scss" scoped>
  .card-telemetry {
    width: 25vw;
    height: 75vh;
    background-color: white;
    margin: 20px;
    overflow: hidden;
    overflow-x: scroll;
    overflow-y: auto;
    white-space: nowrap;


    img {
      height: 300px;
      padding-top: 30px;
    }
    
    .seperate {
      margin: 10px 0;
    }
  }
  .box {
    width: 100px;
    height: 100px;
    background-color: white;
    border: 1px solid grey;
    position: relative;
  }

  .dot {
    width: 20px;
    height: 20px;
    border: 1px solid blue;
    border-radius: 50%;
    position: absolute;
    background-color: rgba(9, 168, 236, 0.42);
  }
</style>