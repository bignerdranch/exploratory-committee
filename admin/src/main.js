import Vue from 'vue'
import router from './router';
// Yes, this is a whole thing
import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'
import App from './App.vue'

Vue.use(VueMaterial)
Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
