<style scoped src="../../assets/styles/index.css">
</style>

<template>
    <div id="wrapper">
        <div id="menu">
            <a href="#" class="signout" @click.prevent="signOut" >Sign out</a>
            <div style="clear:both"></div>
        </div>

        <ul>
            <li v-for="chatroom in chatrooms" :key="chatroom.id" :chatroom="chatroom">
                <router-link id="chatroomlink" v-bind:to="'/chatrooms/' + chatroom.name">{{chatroom.name}}</router-link>
            </li>
        </ul>

        <h3 class="addchatroomtitle">Add a new chatroom</h3>
        <div class="error" v-if="error">{{ error }}</div>
        <form action="" @submit.prevent="addChatroom">
            <input name="chatname"  size="50" class="input" autocomplete="off" placeholder="Type a name" v-model="newChatroom.name" />
            <input type="submit" value="Add Chatroom" />
        </form>
    </div>
</template>


<script>
import ActionCable from "actioncable";

export default {
    name: 'Chatrooms',
    data () {
    return {
      name: '',
      chatrooms: [],
      newChatroom: [],
      error: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/chatrooms/')
        .then(response => { this.chatrooms = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))

      this.cable = ActionCable.createConsumer("ws://localhost:3000/cable?token=" + localStorage.id);

      this.cable.subscriptions.create({ channel: "IndexChannel" } ,
      {
          connected() {
              console.log("CONECTADO")
          },
          rejected() {
              console.log("NO PUDO CONECTAR")
          },
          disconnected() {
              console.log("DESCONECTADO")
          },
          received: this.received
      });
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addChatroom () {
      const value = this.newChatroom
      if (!value) {
        return
      }
      this.$http.secured.post('/chatrooms/', { chatroom: { name: this.newChatroom.name } })
        .then(response => {
          this.newChatroom = []
        })
        .catch(error => this.setError(error, 'Cannot create chatroom'))
    },
    signOut () {
      this.$http.secured.delete('/signin')
        .then(response => {
          delete localStorage.id
          delete localStorage.csrf
          delete localStorage.access
          delete localStorage.signedIn
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    received(data) {
      console.log(data)
      if (data)
          this.chatrooms.push(data)
    }
  }
}
</script>