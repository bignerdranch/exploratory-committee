import Vue from 'vue';
import VueRouter from 'vue-router';
import Projects from './components/projects';
import ProjectContainer from './components/projectContainer';

Vue.use(VueRouter);

export const routes = [
  {
    path: '/',
    name: 'mother',
    component: ProjectContainer,
  },
  {
    path: '/projects',
    name: 'projects',
    component: Projects,
  },
 
];

export default new VueRouter({
  routes,
  mode: 'history',
});
