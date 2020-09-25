<template>
  <canvas
    ref="canvas"
    height="imgWidth"
    width="imgHeight"
    @mousedown="mouseDown"
    @mouseup="mouseUp"
    @mousemove="mouseMove"
  >
  </canvas>
</template>
<script>
export default {
  name: 'SingleScreen',
  data: () => ({
    imgWidth: 0,
    imgHeight: 0,
    hotspots: [],
    rect: {},
    drag: false,
  }),
  props: {
    imgUrl: {
      required: true,
      type: String,
    },
    id: {
      required: true,
      type: Number,
    },
  },
  computed: {
    currCanvas() {
      return this.$refs.canvas;
    },
    canvasContext() {
      return this.currCanvas.getContext('2d');
    },
    canvasBorder() {
      return this.currCanvas.getBoundingClientRect();
    },
    locationInCanvas() {
      // x: rectX - canvasBorderX
      // y: rectY - canvasBorderY
      // h: rect.h
      // w: rect.w

      // add to the array
    },
  },
  methods: {
    drawCanvas() {
      let cnvs = this.$refs.canvas;
      let ctx = cnvs.getContext('2d');
      let bg = new Image();
      bg.src = this.imgUrl;

      bg.onload = () => {
        this.imgWidth = bg.width;
        this.imgHeight = bg.height;

        this.$refs.canvas.width = this.imgWidth;
        this.$refs.canvas.height = this.imgHeight;

        return ctx.drawImage(bg, 0, 0)
      };
    },
    mouseDown(e) {
      console.log('canvas border', this.canvasBorder);
      this.rect.startX = e.pageX - this.canvasBorder.left;
      this.rect.startY = e.pageY - this.canvasBorder.top;
      this.drag = true;
    },
    mouseUp() {
      this.drag = false;
    },
    mouseMove(e) {
      if (this.drag) {
        this.rect.w = (e.pageX - this.canvasBorder.left) - this.rect.startX;
        this.rect.h = (e.pageY - this.canvasBorder.top) - this.rect.startY;

        this.draw();
      }
    },
    draw() {
      this.canvasContext.setLineDash([6]);
      this.canvasContext.strokeRect(this.rect.startX, this.rect.startY, this.rect.w, this.rect.h);
    },
  },
  mounted() {
    this.drawCanvas();
  },
}
</script>
<style scoped>
.screen {
  width: 200px;
  margin: 20px;
}
</style>