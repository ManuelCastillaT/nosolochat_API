import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import ChatroomsIndex from '@/components/ChatroomsIndex'
import Chatroom from '@/components/Chatroom'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/chatrooms',
      name: 'Chatrooms',
      component: ChatroomsIndex
    },
    {
      path: '/chatrooms/:name',
      name: ':name',
      component: Chatroom
    }
  ]
})
