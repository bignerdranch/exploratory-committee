<template>
  <div class="page-container">
    <md-toolbar class="md-primary">
      <md-button class="md-icon-button" @click="openMenu">
        <md-icon>menu</md-icon>
      </md-button>
      
      <md-button class="md-icon-button" @click="setShowDialog()">
        <md-icon>add_circle_outline</md-icon>
      </md-button>

      <md-button class="md-icon-button" @click="AddHotspot()">
        <md-icon>aspect_ratio</md-icon>
      </md-button>

      <md-button class="md-icon-button" @click="refresh()">
        <md-icon>refresh</md-icon>
      </md-button>

      <span class="md-title">{ my project }</span>     
    </md-toolbar>

    <md-dialog :md-active.sync="showImageDialog">
      <md-dialog-title>Upload Screens</md-dialog-title>
      <form enctype="multipart/form-data" novalidate>
        <input 
          type="file" 
          name="uploadFieldName" 
          @change="handleImages($event.target.files)"
          accept="image/*" 
          multiple
          class="input-file">
      </form>
      <md-dialog-actions>
        <md-button class="md-primary" @click="showImageDialog = false">CLOSE</md-button>
        <md-button class="md-primary" @click="saveFiles">UPLOAD</md-button>
      </md-dialog-actions>
    </md-dialog>

    <md-dialog :md-active.sync="showAddProjectDialog">
      <md-dialog-title>Add Project</md-dialog-title>
      <form novalidate class="md-layout" @submit.prevent="addProject">
          <md-card class="md-layout-item md-size-50 md-small-size-100">
            <md-card-content>
                <md-field>
                    <md-input name="add-project-name" id="add-project-name" autocomplete="given-name" v-model="newProjectName"/>
                  </md-field>
              <md-dialog-actions>
                <md-button class="md-primary" @click="showAddProjectDialog = false">CLOSE</md-button>
                <md-button class="md-primary" type="submit">SAVE</md-button>
              </md-dialog-actions>
              </md-card-content>
          </md-card>
      </form>
    </md-dialog>

    <md-drawer :md-active.sync="showNavigation" md-swipeable>
      <md-toolbar class="md-transparent" md-elevation="0">
        <span class="sm-title">YOUR PROJECTS</span>
      </md-toolbar>
      <md-list>
        <md-list-item @click="showAddProjectDialog = true">
            <md-icon>add_circle_outline</md-icon>
            <span class="md-list-item-text">Add New Project</span>
        </md-list-item>
        <md-divider></md-divider>

        <template v-for="(item, index) in projectsList">
          <router-link :key=index :to="{ name: 'Project', params: { id: item._id } }">
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
import API from '../service';

export default {
  name: 'Header',
   props: {
    finished: {
      default: 0,
      type: Number,
    },
  },
  data: () => ({
    showImageDialog: false,
    showAddProjectDialog: false,
    newProjectName: '',
    multiple: null,
    base64ImageList: [],
    showNavigation: false,
    showSidepanel: false,
    numHotspot: 0,
    projectsList: [],
  }),
   watch: {
    finished() {
      console.log('finished recived');
    },
  },
  methods: {
    setShowDialog() {
      this.showImageDialog = true;
    },
    AddHotspot() {
      this.numHotspot++;
      this.$emit('hotspot', this.numHotspot)
    },
    refresh() {
      // TODO: fetch new information
    },
    saveFiles() {
      this.showImageDialog = false;
      this.$emit('screens', this.base64ImageList)
    },
    handleImages(files) {
      Array.from(files).forEach(file =>  this.createBase64Image(file));
    },
    createBase64Image(file) {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = e =>{
          this.base64ImageList.push({ file: e.target.result, name: file.name, uuid: this.uuidv4() });
      };
    },
    async addProject() {
      API.addNewProject(this.newProjectName);
      this.projectsList = await API.getAllProjects();
      this.showAddProjectDialog = false;
      this.newProjectName = '';
    },
    uuidv4() {
       return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) =>  {
        const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });
    },
    async openMenu() {
      this.projectsList = await API.getAllProjects();
      this.showNavigation = true;
    },
  }
}
</script>

<style lang="scss" scoped>
.md-toolbar.md-theme-default.md-primary {
  background-color: rgb(46, 46, 46);

  .md-title {
    flex: 1;
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