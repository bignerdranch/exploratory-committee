<template>
  <div class="telemetry">
    <md-card class="card-telemetry">
        <md-card-header>
        <div class="md-title">Here is your data</div>

        <img src="../assets/Series 4 - 40mm - Space Gray Copy 3@2x.png"/>
      </md-card-header>
    </md-card>
  </div>  
</template>

<script>
import API from '../service';

export default {
  name: "Telemetry",
  data() {
    return {
      information: {},
    }
  }, 

  // beforeRouteEnter(to, from, next) { 
  //   next(async (vm) => {
  //     const test = await API.getTelemetry(this.$route.params.id);
  //     vm.information = test;
  //   })
  // }

  async mounted() {
    const test = await API.getTelemetry(this.$route.params.id);
    console.log('test', test);
    this.information = test;
  }
}
</script>

<style lang="scss" scoped>
  .card-telemetry {
    width: 25vw;
    height: 75vh;
    background-color: white;
    margin: 20px;

    img {
      height: 300px;
    }
  }
</style>