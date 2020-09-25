<template>
  <canvas
    ref="canvas"
    id="canvas"
    class="single-screen"
    @mousedown="mouseDown"
    @mouseup="mouseUp"
    @mousemove="mouseMove"
    :style="`background-image:url(${imgUrl})`"
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
    rect: {
      h: 0,
      w: 0,
      startX: 0,
      startY: 0,
    },
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
    // locationInCanvas() {
    // x: rectX - canvasBorderX
    // y: rectY - canvasBorderY
    // h: rect.h
    // w: rect.w

    // add to the array
    // },
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

        return ctx.rect(0, 0, this.imgWidth, this.imgHeight);
      };
    },
    mouseDown(e) {
      // this.startX = e.pageX - this.canvasBorder.left;
      this.startX = e.pageX;
      this.startY = e.pageY;
      this.drag = true;
    },
    mouseUp() {
      this.drag = false;
    },
    mouseMove(e) {
      if (this.drag) {
        // this.rect.w = (e.pageX - this.canvasBorder.left) - this.rect.startX;
        // this.rect.h = (e.pageY - this.canvasBorder.top) - this.rect.startY;

        const w = e.pageX - this.rect.startX - this.currCanvas.offsetLeft;
        const h = e.pageY - this.rect.startY - this.currCanvas.offsetTop;
        this.draw(w, h, this.rect.startX, this.rect.startY);
      }
      return;
    },
    draw(width, height, x, y) {
      this.canvasContext.clearRect(0, 0, this.currCanvas.width, this.currCanvas.height);
      this.canvasContext.strokeStyle = "blue";
      this.canvasContext.lineWidth = 3;
      this.canvasContext.strokeRect(x, y, width, height);
    },
  },
  mounted() {
    this.drawCanvas();
  },
}
</script>
<style scoped>
.single-screen {
  background-size: cover;
  background-repeat: no-repeat;
}
</style>