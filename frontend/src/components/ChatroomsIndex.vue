<template>
    <div>
      <div class="text-red" v-if="error">{{ error }}</div>
      <h3 class="font-mono font-regular text-3xl mb-4">Add a new chatroom</h3>
      <form action="" @submit.prevent="addChatroom">
        <div class="mb-6">
          <input class="input"
            autofocus autocomplete="off"
            placeholder="Type a name"
            v-model="newChatroom.name" />
        </div>
        <input type="submit" value="Add Chatroom" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
      </form>

      <ul class="list-reset mt-4">
        <li class="py-4" v-for="chatroom in chatrooms" :key="chatroom.id" :chatroom="chatroom">

          <div class="flex items-center justify-between flex-wrap">
            <h2><router-link v-bind:to="'/chatrooms/' + chatroom.name">{{chatroom.name}}</router-link></h2>
          </div>
        </li>
      </ul>
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
    received(data) {
      console.log(data)
      if (data)
          this.chatrooms.push(data)
    }
  }
}
</script>