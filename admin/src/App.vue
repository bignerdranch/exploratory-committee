
<template>
  <div id="app">
    <Header @screens="setScreens" @hotspot="setHotspot" :finished="finished" :projectName="projectName" />
    <router-view  
      :screens="screens" 
      :hotspot="hotspot" 
      @finished-drawing="setFinished"
      @project-name="setProjectName"
      ></router-view>
  </div>
</template>

<script>
import Header from './components/header';
export default {
 components: {
    Header,
  },
 data: () => ({
   screens: 0,
   hotspot: 0,
   finished: 0,
   projectName: '',
  }),
  methods: {
    setScreens() {
      this.screens++;
    },
    setHotspot(val) {
      this.hotspot = val;
    },
    setFinished(val) {
      this.finished = val;
    },
    setProjectName(name) {
      this.projectName = name;
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
