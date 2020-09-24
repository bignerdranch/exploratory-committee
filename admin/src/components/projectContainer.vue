<template>
  <div>
    <Header @screens="setScreens" @hotspot="setHotspot" :finished="finished"/>
    <Project :screens="screens" :hotspot="hotspot" @finished-drawing="setFinished"/>
  </div>
</template>

<script>
import Header from './header';
import Project from './project';
export default {
 components: {
    Header,
    Project,
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

<style>

</style>