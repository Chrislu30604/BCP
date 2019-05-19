import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Project from './views/Project.vue'
import Launch from './views/Launch.vue'
import Account from './views/Account.vue'
import Login from './views/Login.vue'
import Register from './views/Register.vue'
import LoginFirst from "./views/LoginFirst.vue"
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
    },
    {
      path: '/login',
      name: 'login',
      component: Login
    },
    {
      path: '/register',
      name: 'register',
      component: Register
    },
    {
      path: '/loginfirst',
      name: 'loginfirst',
      component: LoginFirst
    },
  ]
})
