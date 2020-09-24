// export const mainRouter = new VueRouter({
//   // URL query parser that can handle nested objects
//   // https://github.com/ljharb/qs
//   // parseQuery: qs.parse,
//   routes: [
//     {
//       component: App,
//       path: "/",
//     },
//   ],
//   // stringifyQuery(query) {
//   //   const result = qs.stringify(query);
//   //   return result ? `?${result}` : "";
//   // },
// });

import Vue from 'vue';
import VueRouter from 'vue-router';
import Projects from './components/projects';
import Project from './components/project';

Vue.use(VueRouter);

export const routes = [
  {
    path: '/',
    name: 'mother',
    component: Project,
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
