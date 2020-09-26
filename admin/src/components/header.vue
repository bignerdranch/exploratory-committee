<template>
  <div class="page-container">
    <md-toolbar class="md-primary">
      <md-button
        class="md-icon-button"
        @click="openMenu"
      >
        <md-icon>menu</md-icon>
      </md-button>

      <md-button
        class="md-icon-button"
        @click="setShowDialog()"
      >
        <md-icon>add_circle_outline</md-icon>
      </md-button>

      <md-button
        class="md-icon-button"
        @click="AddHotspots()"
      >
        <md-icon>aspect_ratio</md-icon>
      </md-button>

      <md-button
        class="md-icon-button"
        @click="refresh()"
      >
        <md-icon>refresh</md-icon>
      </md-button>

      <span
        class="md-title"
        v-if="isItRoute"
        text-transforma
      >{{ projectName }}</span>
      <span
        class="md-title"
        v-else
        text-transforma
      >Geoffrey</span>
    </md-toolbar>

    <md-dialog :md-active.sync="showImageDialog">
      <md-dialog-title>Upload Screens</md-dialog-title>
      <form
        enctype="multipart/form-data"
        novalidate
        v-on:submit.prevent="saveSceens"
      >
        <input
          type="file"
          name="uploadFieldName"
          @change="handleUpload($event)"
          accept="image/*"
          multiple
          class="input-file"
        >
      </form>
      <md-dialog-actions>
        <md-button
          class="md-primary"
          @click="showImageDialog = false"
        >CLOSE</md-button>
        <md-button
          class="md-primary"
          type="submit"
          @click="saveSceens"
        >UPLOAD</md-button>
      </md-dialog-actions>
    </md-dialog>

    <md-dialog :md-active.sync="showAddProjectDialog">
      <md-dialog-title>Add Project</md-dialog-title>
      <form
        novalidate
        class="md-layout"
        @submit.prevent="addProject"
      >
        <md-card class="md-layout-item md-size-50 md-small-size-100">
          <md-card-content>
            <md-field>
              <md-input
                name="add-project-name"
                id="add-project-name"
                autocomplete="given-name"
                v-model="newProjectName"
              />
            </md-field>
            <md-dialog-actions>
              <md-button
                class="md-primary"
                @click="showAddProjectDialog = false"
              >CLOSE</md-button>
              <md-button
                class="md-primary"
                type="submit"
              >SAVE</md-button>
            </md-dialog-actions>
          </md-card-content>
        </md-card>
      </form>
    </md-dialog>

    <md-drawer
      :md-active.sync="showNavigation"
      md-swipeable
    >
      <md-toolbar
        class="md-transparent"
        md-elevation="0"
      >
        <span class="sm-title">YOUR PROJECTS</span>
      </md-toolbar>
      <md-list>
        <md-list-item @click="showAddProjectDialog = true">
          <md-icon>add_circle_outline</md-icon>
          <span class="md-list-item-text">Add New Project</span>
        </md-list-item>
        <md-divider></md-divider>

        <template v-for="(item, index) in projectsList">
          <router-link
            :key="index"
            :to="{ name: 'Project', params: { id: item._id } }"
          >
            <md-list-item>
              <md-icon>watch</md-icon>
              <span class="md-list-item-text">{{ item.name }}</span>
            </md-list-item>
          </router-link>
        </template>
      </md-list>
    </md-drawer>
  </div>
</template>

<script>
import axios from 'axios';
import API from '../service';

export default {
  name: 'Header',
  props: {
    projectName: {
      default: '',
      type: String,
    },
    finished: {
      default: 0,
      type: Number,
    },
  },
  data: () => ({
    showImageDialog: false,
    showAddProjectDialog: false,
    multiple: null,
    showNavigation: false,
    numHotspot: 0,
    newProjectName: '',
    projectsList: [],
    urls: [],
  }),
  watch: {
    finished() {
      console.log('finished recived');
    },
  },

  computed: {
    isItRoute() {
      return ['Project'].indexOf(this.$route.name) > -1;
    },
  },

  methods: {
    setShowDialog() {
      this.showImageDialog = true;
    },

    AddHotspots() {
      this.numHotspot++;
      this.$emit('save-hotspot', this.numHotspot)
    },

    refresh() {
      location.reload();
    },

    async saveSceens() {
      this.showImageDialog = false;
      await API.saveScreens(this.$route.params.id, this.urls);
      this.$emit('screens')
    },

    async addProject() {
      const id = await API.addNewProject(this.newProjectName);
      this.projectsList = await API.getAllProjects();
      this.showAddProjectDialog = false;
      this.showNavigation = false;
      this.newProjectName = '';
      this.$router.push({ path: `/project/${id}` })
    },

    async openMenu() {
      this.projectsList = await API.getAllProjects();
      this.showNavigation = true;
    },
    // CLOUDINARY UPLAOD IMAGES
    async handleUpload(event) {
      const files = event.target.files;
      files.forEach(file => {
        let reader = new FileReader();
        const cloudName = 'dunnisf1r';
        const uploadPreset = 'o5jxetvn';

        reader.addEventListener('load', async function () {
          let cloudinaryUploadULR = `https://api.cloudinary.com/v1_1/${cloudName}/upload`;
          let requestObj = {
            url: cloudinaryUploadULR,
            method: 'POST',
            data: {
              upload_preset: uploadPreset,
              tags: file.name,
              file: reader.result,
            },
          };

          const res = await axios(requestObj);
          this.urls.push({ url: res.data.url, name: file.name, uuid: this.uuidv4(), hotspots: [] })
        }.bind(this), false);

        reader.readAsDataURL(file);
      })
    },
    uuidv4() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
        const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });
    },
  }
}
</script>

<style lang="scss" scoped>
.md-toolbar.md-theme-default.md-primary {
  background-color: rgb(46, 46, 46);

  .md-title {
    flex: 1;
    text-transform: capitalize;
  }
}

.add-project.md-button {
  width: 80%;
  text-align: left;
}

.add-project-icon {
  margin: 10px;
}

.md-dialog /deep/.md-dialog-container {
  width: 768px;
  padding: 20px;
}
</style>