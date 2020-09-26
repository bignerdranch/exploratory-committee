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
    uuid: {
      required: true,
      type: String,
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
      this.startX = e.pageX - this.canvasBorder.top;
      console.log(this.startX);
      // this.rect.startX = e.pageX;
      this.startY = e.pageY - this.canvasBorder.left;
      // this.rect.startY = e.pageY;
      this.drag = true;
    },
    mouseUp() {
      this.drag = false;
      this.submitHotspot();
    },
    mouseMove(e) {
      if (this.drag) {
        this.rect.w = (e.pageX - this.canvasBorder.left) - this.rect.startX;
        this.rect.h = (e.pageY - this.canvasBorder.top) - this.rect.startY;

        this.draw();
      }
      return;
    },
    draw() {
      this.canvasContext.clearRect(0, 0, this.currCanvas.width, this.currCanvas.height);
      this.canvasContext.strokeStyle = 'blue';
      this.canvasContext.lineWidth = 3;
      this.canvasContext.strokeRect(this.rect.startX, this.rect.startY, this.rect.w, this.rect.h);
    },
    submitHotspot() {
      this.$emit('add-hotspot', { rect: { ...this.rect, uuid: this.uuidv4() }, uuid: this.uuid });
    },
    uuidv4() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
        const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });
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