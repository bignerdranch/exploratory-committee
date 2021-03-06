<template>
  <div class="container">
    <div class="side1">
      <div id="screen-wrapper">
        <template v-for="(screen) in PROJECT.screens">
        <md-card
          :key="screen.name"
          class="screen-card"
        >
        <div :id="screen.uuid">
          <img :src="screen.url" :uuid="screen.uuid" class="screen"/>
        </div>
          <md-divider></md-divider>
          <div class="info-wrapper">
            <label class="screen-label">{{ screen.name }}</label>
            <button
              class="btn-check-first"
              @click="markAsFirst(screen.uuid)"
              :class="{'first': screen.firstScreen}"
            >
              <md-icon v-if="screen.firstScreen">first_page</md-icon>
              <md-icon v-else>info_outline</md-icon>
            </button>
          </div>
        </md-card>
      </template>
    </div>

    <md-dialog :md-active.sync="showMenu">
      <form
        novalidate
        class="md-layout"
        @submit.prevent="setActionsOnSpot"
      >
        <md-card class="md-layout-item">
          <md-card-content>
            <md-field>
              <label for="Target">Target</label>
              <select
                name="target"
                id="target"
                v-model="targetScreen"
              >
                <option></option>
                <template v-for="(screen, index) in PROJECT.screens">
                  <option
                    :value="screen.uuid"
                    :key="index"
                  >{{ screen.name }}</option>
                </template>
              </select>
            </md-field>

            <md-field>
              <label for="transition">Transition</label>
              <select
                name="transition"
                id="transition"
                v-model="targetTransition"
              >
                <option></option>
                <template v-for="(transition, index) in transitionList">
                  <option
                    :value="transition"
                    :key="index"
                  >{{ transition }}</option>
                </template>
              </select>
            </md-field>

            <md-field>
              <label for="transition">Triggers</label>
              <select
                name="triggers"
                id="triggers"
                v-model="targetTrigger"
              >
                <option></option>
                <template v-for="(trigger, index) in triggersList">
                  <option
                    :value="trigger"
                    :key="index"
                  >{{ trigger }}</option>
                </template>
              </select>
            </md-field>
          </md-card-content>

          <md-card-actions>
            <md-button
              type="submit"
              class="md-primary"
            >Done</md-button>
          </md-card-actions>
        </md-card>
      </form>
    </md-dialog>
  </div>
  <Telemetry  class="telemery" :screens="PROJECT.screens"/>
  </div>
</template>

<script>
import API from '../service';
import Telemetry from './telemetry';

export default {
  name: 'Project',
  components: { Telemetry },
  props: {
    screens: {
      default: 0,
      type: Number,
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
    showMenu: false,
    transitionList: ['left', 'right', 'top', 'bottom', 'fade', 'instant', 'restart'],
    triggersList: ['swipeleft', 'swiperight', 'swipeup', 'swipedown', 'tap', 'longpress', 'pause'],
    // FORM
    targetScreen: '',
    targetTransition: '',
    targetTrigger: '',
    currentHotspotEdit: '',
    parentTriggersId: '',
    hotspotTriggerId: '',
    PROJECT: {},
  }),

  beforeRouteEnter(to, from, next) {
    next(async (vm) => {
      vm.PROJECT = await API.getProject(to.params.id);
      vm.$emit('project-name', vm.PROJECT.name);
      vm.listeners();
      // RESEY ALL VALUES
      vm.x1 = null;
      vm.y1 = null;
      vm.x2 = null;
      vm.y2 = null;
      vm.targer = null;
      vm.index = 0;
      vm.numOfClicks = 0;
      vm.finishedDrawing = 0;
      vm.listOfTargets = [];
      vm.screensWithHotspots = [];
      vm.currentParent = '';
      vm.showMenu = false;
      vm.parentTriggersId = '';
      vm.hotspotTriggerId = '';
    });
  },

  async beforeRouteUpdate(to, from, next) {
    this.PROJECT = await API.getProject(to.params.id);
    this.$emit('project-name', this.PROJECT.name);
    this.listeners();
    // RESEY ALL VALUES
    this.x1 = null;
    this.y1 = null;
    this.x2 = null;
    this.y2 = null;
    this.targer = null;
    this.index = 0;
    this.numOfClicks = 0;
    this.finishedDrawing = 0;
    this.listOfTargets = [];
    this.screensWithHotspots = [];
    this.currentParent = '';
    this.showMenu = false;
    this.parentTriggersId = '';
    this.hotspotTriggerId = '';

    next();
  },

  watch: {
    async hotspot() {
      await API.saveScreens(this.$route.params.id, this.PROJECT.screens);
    },
    async screens() {
      this.PROJECT = await API.getProject(this.$route.params.id);
    },
    numOfClicks() {
      if (this.numOfClicks === 2) {
        const rec = this.listOfTargets[this.finishedDrawing];
        rec.addEventListener('contextmenu', this.openTriggerMenu, true)
        this.drawRec(this.listOfTargets[this.finishedDrawing]);

        const parentScreen = this.currentParent;
        const hotspot = this.listOfTargets[this.finishedDrawing];
        const parentElementCoordinates = document.querySelectorAll(`[uuid="${parentScreen}"]`)[0].getBoundingClientRect();
        const parentWidth = parentElementCoordinates.width;
        const parentHeigth = parentElementCoordinates.height;
        const calcX =  this.x2 - parentElementCoordinates.left;
        const calcY =  this.y2 - parentElementCoordinates.top;
        const calcWidth = Math.abs(this.x2 - this.x1);
        const calcHeight = Math.abs(this.y2 - this.y1);

        const i = this.PROJECT.screens.findIndex(i => i.uuid === parentScreen);
        const howManyHotspots = this.PROJECT.screens[i].hotspots.length;
        this.$set(
          this.PROJECT.screens[i].hotspots,
          howManyHotspots, 
          {
            id: hotspot.getAttribute('id'),
            xWeb: calcX,
            yWeb: calcY,
            widthWeb: calcWidth,
            heightWeb: calcHeight,
            x: calcX / parentWidth,
            y: calcY / parentHeigth,
            width: calcWidth / parentWidth,
            height: calcHeight / parentHeigth,
          });
        this.finishedDrawing++;
        this.numOfClicks = 0;
      }
    }
  },

  updated() {
    this.$nextTick(() => {
      this.listeners();
      this.removeOldBoxes();
      this.checkHotspotsAndDraw();
    });
  },

  methods: {
    removeOldBoxes() {
      const boxes = [...document.getElementsByClassName('hotspot')];
      boxes.forEach((box, i) => {
        console.log(box);
        box.parentNode.removeChild(boxes[i]);
      });
    },
    addHotspot(data) {
      const i = this.PROJECT.screens.findIndex(i => i.uuid === data.uuid);
      this.$set(this.PROJECT.screens[i].hotspots, this.PROJECT.screens[i].hotspots.length, data.rect);
    },

    startHotspot(parentScreen) {
      this.x1 = null;
      this.x2 = null;
      this.y1 = null;
      this.y2 = null;
      this.currentParent = '';
      const target = document.createElement('div');
      target.setAttribute("id", this.uuidv4());
      target.setAttribute("parent", parentScreen);
      target.setAttribute("class", "hotspot");
      document.getElementById('screen-wrapper').appendChild(target);
      target.style.border = "1px solid blue";
      target.style.position = "absolute";
      target.style.backgroundColor = "rgba(9, 168, 236, 0.42)";
      target.style.zIndex = "2";
      this.listOfTargets.push(target);
      this.currentParent = parentScreen;
    },
    listeners() {
      const listOfImages = document.getElementsByClassName("screen");

      listOfImages.forEach(image => {
        image.addEventListener('mousedown', this.handlerOnMouseDown, true);
        image.addEventListener('mouseup', this.removeListeners, true);
      });
    },
    removeListeners(e) {
      this.x2 = e.clientX;
      this.y2 = e.clientY;
      document.removeEventListener('mousedown', this.handlerOnMouseDown, true);
      document.removeEventListener('mouseup', this.removeListeners, true);
    },
    handlerOnMouseDown(e) {
      if (this.numOfClicks === 0) {
        const parentScreenUuid = e.target.attributes.uuid.value;
        this.startHotspot(parentScreenUuid);
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
    openTriggerMenu(e) {
      this.parentTriggersId = e.target.attributes.parent.value;
      this.hotspotTriggerId = e.target.attributes.id.value;
      e.preventDefault();
      this.showMenu = true;
    },
    async setActionsOnSpot() {
      const parentIndex = this.PROJECT.screens.findIndex(i => i.uuid === this.parentTriggersId);
      const hotspotIndex = this.PROJECT.screens[parentIndex].hotspots.findIndex(i => i.id === this.hotspotTriggerId)
      const updatedHotspot = {...this.PROJECT.screens[parentIndex].hotspots[hotspotIndex],
          trigger:  this.targetTrigger,
          transition: this.targetTransition,
          destination: this.targetScreen,
        };

      this.$set(this.PROJECT.screens[parentIndex].hotspots, hotspotIndex, updatedHotspot);
      // RESET
      this.targetTrigger = '';
      this.targetTransition = '';
      this.targetScreen = '';
      this.currentHotspotEdit = '';
      this.parentTriggersId = '';
      this.hotspotTriggerId = '';
      this.showMenu = false;
    },
    uuidv4() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
        const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });
    },

    async markAsFirst(uuid) {
      const i = this.PROJECT.screens.findIndex(i => i.uuid === uuid);
      this.PROJECT.screens[i] = { ...this.PROJECT.screens[i], firstScreen: true };
      
      // TODO
      // use $set to apply changes without refresh
      this.PROJECT.screens.forEach((part, index) => {
        part['firstScreen'] = false;
        if (i === index) {
          part['firstScreen'] = true;
        }
      });

      await API.saveScreens(this.$route.params.id, this.PROJECT.screens);
    },

    checkHotspotsAndDraw() {
      this.PROJECT.screens.forEach(screen => {
        screen.hotspots.forEach(i => {
          const target = document.createElement('div');
          target.setAttribute("id", i.id);
          target.setAttribute("parent", screen.uuid);
          document.getElementById(screen.uuid).appendChild(target);
          target.style.border = "1px solid blue";
          target.style.position = "absolute";
          target.style.backgroundColor = "rgba(9, 168, 236, 0.42)";
          target.style.zIndex = "100";
          // drawing the hotspot
          target.style.left = i.xWeb + 'px';
          target.style.top = i.yWeb + 'px';
          target.style.width = i.widthWeb + 'px';
          target.style.height = i.heightWeb + 'px';
        });
      });
    },
  },
};
</script>

<style lang="scss" scoped>

.container {
  display: flex;
  flex-direction: row;

  .side1 {
    flex: 1;
  }
}
.screen-wrapper {
  overflow-x: scroll;
  overflow-y: hidden;
  height: 500px;
  white-space: nowrap;
}

.screen {
  width: 200px;
}

.screen-card {
  width: 200px;
  margin: 20px;
  display: inline-block;

  .screen-label {
    padding: 10px;
    color: grey;
  }

  .info-wrapper {
    padding: 5px;

    .screen-label {
      white-space: nowrap;
      overflow: hidden;
      width: 150px;
      text-overflow: ellipsis;
      display: inline-block;
    }

    .first.btn-check-first {
      i {
        color: green;
      }
    }
    .btn-check-first {
      background-color: transparent;
      border: none;
      cursor: pointer;

      i {
        display: inline-block;
        color: grey;
      }
    }
  }
}

.md-field.md-theme-default /deep/ {
  label {
    top: -7px;
  }
}

#target,
#transition,
#triggers /deep/ {
  border: none;
  width: 100%;
}
</style>