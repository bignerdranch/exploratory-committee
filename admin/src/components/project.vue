<template>
  <div>
    <div id="screen-wrapper">
      <template v-for="(screen, index) in screens">
        <single-screen
          :imgUrl="screen"
          :key="index"
          :id="index"
          class="screen"
        ></single-screen>
      </template>
    </div>
  </div>
</template>

<script>
import SingleScreen from './singleScreen';

export default {
  name: 'Project',
  components: {
    SingleScreen,
  },
  props: {
    screens: {
      required: true,
      type: Array,
    },
    hotspot: {
      default: 0,
      type: Number,
    },
  },
  data: () => ({
    x1: null,
    y1: null,
    x2: null,
    y2: null,
    targer: null,
    index: 0,
    numOfClicks: 0,
    finishedDrawing: 0,
    listOfTargets: [],
    screensWithHotspots: [],
    currentParent: '',
  }),
  watch: {
    hotspot() {
      this.listeners();
      this.index++;
    },
    numOfClicks() {
      if (this.numOfClicks === 2) {
        this.drawRec(this.listOfTargets[this.finishedDrawing]);
        this.screensWithHotspots.push({
          screen: this.currentParent, hotspot: {
            x1: this.x1,
            y1: this.y1,
            x2: this.x2,
            y2: this.y2,
          }
        });
        this.finishedDrawing++;
        this.numOfClicks = 0;
      }
    }
  },
  methods: {
    startHotspot(parentScreen) {
      this.x1 = null;
      this.x2 = null;
      this.y1 = null;
      this.y2 = null;
      this.currentParent = '';
      const target = document.createElement('div');
      const generateId = Math.random();
      target.setAttribute("id", generateId);
      document.getElementById('screen-wrapper').appendChild(target);
      target.style.border = "1px solid blue";
      target.style.position = "absolute";
      target.style.backgroundColor = "rgba(9, 168, 236, 0.42)";
      this.listOfTargets.push(target);
      this.currentParent = parentScreen;
    },
    listeners() {
      const listOfImages = document.getElementsByClassName("screen");

      listOfImages.forEach(image => {
        image.addEventListener('mousedown', this.handlerOnMouseDown, true);
        // image.addEventListener('mousemove', this.handlerOnMouseMove, true);
        image.addEventListener('mouseup', this.removeListeners, true);
      });
    },
    removeListeners(e) {
      console.log('mouse up', e.clientX, e.clientY);
      this.x2 = e.clientX;
      this.y2 = e.clientY;
      document.removeEventListener('mousedown', this.handlerOnMouseDown, true);
      // document.removeEventListener('mousemove', this.handlerOnMouseMove, true);
      document.removeEventListener('mouseup', this.removeListeners, true);
    },
    handlerOnMouseDown(e) {
      if (this.numOfClicks === 0) {
        this.startHotspot(e.target.currentSrc);
      }
      this.numOfClicks++;
      this.x1 = e.clientX;
      this.y1 = e.clientY;
    },
    drawRec(target) {
      var x3 = Math.min(this.x1, this.x2);
      var x4 = Math.max(this.x1, this.x2);
      var y3 = Math.min(this.y1, this.y2);
      var y4 = Math.max(this.y1, this.y2);
      target.style.left = x3 + 'px';
      target.style.top = y3 + 'px';
      target.style.width = x4 - x3 + 'px';
      target.style.height = y4 - y3 + 'px';
    },
  },
};
</script>

<style lang="scss" scoped>
.screen-wrapper {
  overflow-x: scroll;
  overflow-y: hidden;
  height: 500px;
  white-space: nowrap;
}

.screen {
  width: 200px;
  margin: 20px;
}

// canvas {
//   width: 200px;
//   background-color: turquoise;
//   border: 1px solid blue;
// }
</style>