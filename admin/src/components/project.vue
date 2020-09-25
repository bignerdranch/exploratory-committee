<template>
  <div>
    <div id="screen-wrapper">
      <template v-for="(screen) in PROJECT.screens">
        <md-card
          :key="screen.name"
          class="screen-card"
        >
          <single-screen
            :imgUrl="screen.url"
            :key="index"
            :uuid="screen.uuid"
            class="screen"
            @add-hotspot="addHotspot"
          ></single-screen>
          <md-divider></md-divider>
          <div class="info-wrapper">
            <label class="screen-label">{{ screen.name }}</label>
            <button
              class="btn-check-first"
              @click="markAsFirst(screen.uuid)"
              :class="{'first': screen.firstScreen}"
            >
              <md-icon>check_mark</md-icon>
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
                    :value="screen.name"
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
</template>

<script>
import API from '../service';
import SingleScreen from './singleScreen';

export default {
  name: 'Project',
  components: {
    SingleScreen,
  },
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
    transitionList: ['left', 'right', 'top', 'bottom', 'fade', 'instant'],
    triggersList: ['swipeleft', 'swiperight', 'swipeup', 'swipedown', 'tap', 'longpress'],
    // FORM
    targetScreen: '',
    targetTransition: '',
    targetTrigger: '',
    currentHotspotEdit: '',
    PROJECT: {},
  }),

  beforeRouteEnter(to, from, next) {
    next(async (vm) => {
      vm.PROJECT = await API.getProject(to.params.id);
      vm.$emit('project-name', vm.PROJECT.name);
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
    });
  },

  async beforeRouteUpdate(to, from, next) {
    this.PROJECT = await API.getProject(to.params.id);
    this.$emit('project-name', this.PROJECT.name);
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

    next();
  },

  watch: {
    hotspot() {
      // call API 
      this.listeners();
      this.index++;
    },
    async screens() {
      this.PROJECT = await API.getProject(this.$route.params.id);
    },
    numOfClicks() {
      if (this.numOfClicks === 2) {
        const rec = this.listOfTargets[this.finishedDrawing];
        rec.addEventListener('contextmenu', this.openTriggerMenu, true)
        this.drawRec(this.listOfTargets[this.finishedDrawing]);
        const el = this.listOfTargets[this.finishedDrawing];
        this.screensWithHotspots.push({
          screen: this.currentParent, hotspot: {
            id: el.getAttribute('id'),
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
    openTriggerMenu(e) {
      this.currentHotspotEdit = e.srcElement.id
      e.preventDefault();
      this.showMenu = true;
    },
    setActionsOnSpot() {
      const index = this.screensWithHotspots.findIndex(el => el.hotspot.id === this.currentHotspotEdit);
      this.screensWithHotspots[index].hotspot['trigger'] = this.targetTrigger;
      this.screensWithHotspots[index].hotspot['transition'] = this.targetTransition;
      this.screensWithHotspots[index].hotspot['destination'] = this.targetScreen;
      // RESET
      this.targetTrigger = '';
      this.targetTransition = '';
      this.targetScreen = '';
      this.currentHotspotEdit = '';
      this.showMenu = false;

      // CALL API TO UPDATE THE SCREENS
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

      this.PROJECT.screens.forEach((part, index) => {
        part['firstScreen'] = false;
        if (i === index) {
          part['firstScreen'] = true;
        }
      });

      await API.saveScreens(this.$route.params.id, this.PROJECT.screens);
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