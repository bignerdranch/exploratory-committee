<template>
  <div class="page-container">
    <md-toolbar class="md-primary">
      <md-button class="md-icon-button" @click="showNavigation = true">
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

    <md-dialog :md-active.sync="showDialog">
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
        <md-button class="md-primary" @click="showDialog = false">CLOSE</md-button>
        <md-button class="md-primary" @click="saveFiles">UPLOAD</md-button>
      </md-dialog-actions>
    </md-dialog>

    <md-drawer :md-active.sync="showNavigation" md-swipeable>
      <md-toolbar class="md-transparent" md-elevation="0">
        <span class="sm-title">YOUR PROJECTS</span>
      </md-toolbar>
      <md-list>
        <md-list-item @click="addProject()">
          <md-icon>add_circle_outline</md-icon>
          <span class="md-list-item-text">Add New Project</span>
        </md-list-item>
        <md-divider></md-divider>
      <!-- SIDE MENU OPEN -->
        <md-list-item>
          <md-icon>move_to_inbox</md-icon>
          <span class="md-list-item-text">project 1</span>
        </md-list-item>

        <md-list-item>
          <md-icon>send</md-icon>
          <span class="md-list-item-text">projcet 2</span>
        </md-list-item>

      </md-list>
    </md-drawer>
  </div>
</template>

<script>
export default {
  name: 'Header',
  data: () => ({
    showDialog: false,
    multiple: null,
    base64ImageList: [],
    showNavigation: false,
    showSidepanel: false,
  }),
  methods: {
    setShowDialog() {
      console.log('show dialog clicked');
      this.showDialog = true;
    },
    AddHotspot() {
      this.$emit('hotspot', true);
    },
    refresh() {
      // TODO: fetch new information
    },
    saveFiles() {
      this.showDialog = false;
      this.$emit('screens', this.base64ImageList)
    },
    handleImages(files) {
      Array.from(files).forEach(file =>  this.createBase64Image(file));
    },
    createBase64Image(file) {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = e =>{
          this.base64ImageList.push(e.target.result);
      };
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