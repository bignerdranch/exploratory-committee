<template>
  <div>
    <Header @screens="setScreens" @hotspot="setHotspot"/>
    <Project :screens="screens" :hotspot="hotspot"/>
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
   hotspot: false,
  }),
  methods: {
    setScreens(screens) {
      this.screens = screens;
    },
    setHotspot(val) {
      this.hotspot = val;
    },
  }
}
</script>

<style>

</style>