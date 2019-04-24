import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Project from './views/Project.vue'
import Launch from './views/Launch.vue'
import Account from './views/Account.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    },
    {
      path: '/project',
      name: 'project',
      component: Project
    },
    {
      path: '/launch',
      name: 'launch',
      component: Launch
    },
    {
      path: '/account',
      name: 'account',
      component: Account 
    }
  ]
})
