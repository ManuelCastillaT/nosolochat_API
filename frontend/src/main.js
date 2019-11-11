// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import VueAxios from 'vue-axios'
import ActionCable from "actioncable";

import { securedAxiosInstance, plainAxiosInstance } from './backend/axios'
// import { cable } from './backend/actioncable'


Vue.config.productionTip = false

Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
})

Vue.use(ActionCable, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: 'http://localhost:3000/cable',
  connectImmediately: true
});

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  // cable,
  securedAxiosInstance,
  plainAxiosInstance,
  components: { App },
  template: '<App/>'
}).$mount('#app');