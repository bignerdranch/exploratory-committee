
<template>
  <div id="app">
    <Header @screens="setScreens" @hotspot="setHotspot" :finished="finished"/>
    <router-view  :screens="screens" :hotspot="hotspot" @finished-drawing="setFinished"></router-view>
  </div>
</template>

<script>
import Header from './components/header';
export default {
 components: {
    Header,
  },
 data: () => ({
   screens: [],
   hotspot: 0,
   finished: 0,
  }),
  methods: {
    setScreens(screens) {
      this.screens = screens;
    },
    setHotspot(val) {
      this.hotspot = val;
    },
    setFinished(val) {
      this.finished = val;
    }
  }
}
</script>

<style lang="scss" scoped>
#app {
  background-color: rgba(230, 230, 230, 1);  
  height: 100vh;
}
</style>
