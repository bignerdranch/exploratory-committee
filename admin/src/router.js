import Vue from 'vue';
import VueRouter from 'vue-router';
import Projects from './components/projects';
import Project from './components/project';

Vue.use(VueRouter);

export const routes = [
  {
    path: '/',
    component: Projects,
  },
  {
    path: '/project/:id',
    name: 'Project',
    component: Project,
  },
];

export default new VueRouter({
  routes,
  mode: 'history',
});
