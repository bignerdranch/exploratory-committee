<template>
  <div>
    <div id="screen-wrapper">
      <template v-for="(screen, index) in screens" >
      <img :key="index" :src="screen" class="screen" />
      </template>
    </div>
  </div>  
</template>

<script>
export default {
  name: 'Project',
  props: {
    screens: {
      required: true,
      type: Array,
    },
    hotspot: {
      default: false,
      type: Boolean,
    },
  },
  data: () => ({
    x1: null,
    y1: null,
    x2: null,
    y2: null,
    targer: null,
    index: 0,
  }),
  watch: {
    hotspot() {
      this.startHotspot();
      this.index++;
    },
  },
  methods: {
    startHotspot() {
      this.target = document.createElement('div');
      this.target.setAttribute("id", this.index);
      document.getElementById('screen-wrapper').appendChild(this.target);
      this.target.style.border = "1px solid blue";
      this.target.style.position = "absolute";

      document.addEventListener('mousedown', e => {
        console.log('mousedown', e);
        // this.target.hidden = 0;
        this.x1 = e.clientX;
        this.y1 = e.clientY;
        this.reCalc();
      });

      document.addEventListener('onmousemove', (e) => {
        console.log('onmousemove');
        this.x2 = e.clientX;
        this.y2 = e.clientY;
        this.reCalc();
      });

      document.addEventListener('onmouseup', (e) => {
        console.log('finsihed?', e, this.index);
      })
    },
    reCalc() {
      var x3 = Math.min(this.x1, this.x2);
      var x4 = Math.max(this.x1, this.x2);
      var y3 = Math.min(this.y1, this.y2);
      var y4 = Math.max(this.y1, this.y2);
      this.target.style.left = x3 + 'px';
      this.target.style.top = y3 + 'px';
      this.target.style.width = x4 - x3 + 'px';
      this.target.style.height = y4 - y3 + 'px';
    },
  },
};
</script>

<style lang="scss" scoped>
.screen-wrapper {
  overflow-x: scroll;
  overflow-y: hidden;
  height: 500px;
  white-space:nowrap
}

.screen {
  width: 200px;
  margin: 20px;
}
</style>