<template>
  <div class="header-wrapper">
    <ul>
      <li class="title"> MOTHER </li>
      <li><button @click="addScreens()">+ Add Screens</button> </li>
      <li class="hotspot-wrapper"><button @click="AddHotspot()">Add Hotspot <span class="hotspot"></span></button> </li>
    </ul>

    <span class="project-title">Project Title</span>

    <router-link :to="{ name: 'projects'}">All Projects</router-link>
  </div>
</template>

<script>
export default {
  name: 'Header',
  methods: {
    addScreens() {
      console.log('ADD SCREENS CLICKED');
    },
    AddHotspot() {
      console.log('ADD HOTSPOT CLICKED');
    },
  }
}
</script>

<style lang="scss" scoped>
.header-wrapper {
  padding-bottom: 40px;
  border-bottom: 1px black solid;
  justify-content: space-between;
}

.header-wrapper, ul {
  display: flex;
  font-weight: bold;
}

ul {
  list-style: none;
  margin: 0;
  
  li {
    margin-right: 20px;

    button {
      font-weight: bold;
    }
  }

 .title {
    border: 1px solid grey;
    padding: 2px 20px;
    margin-top: -2px;
  }

  li > button, button:visited, button:hover, button:active, button:focus {
    background-color: transparent;
    border: none;
    cursor: pointer;
    outline: none;
  }

  .hotspot-wrapper {
    width: 150px;
    
    button {
      white-space: nowrap;
      cursor: pointer;
    }

    .hotspot {
      padding: 5px 15px;
      margin-left: 10px;
      background-color: rgb(175,238,238);
      border: 1px solid grey;
    }
  }
}

.project-title {
  margin-left: -300px;
}

a {
  color: inherit;
  text-decoration: inherit;
}
</style>