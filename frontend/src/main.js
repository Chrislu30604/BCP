import Vue from 'vue'
import './plugins/vuetify'
import VeeValidate from 'vee-validate'
import VueDarkMode from "vuedarkmode";
import axios from 'axios'
import VueAxios from 'vue-axios'
import App from './App.vue'
import router from './router'
import {store} from './store/store'

Vue.use(VueAxios, axios);
Vue.use(VueDarkMode);
Vue.use(VeeValidate);

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
