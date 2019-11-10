<template>
    <div>
    <h1>Chatroom: {{ this.$route.params.name }}</h1>

    <ul class="list-reset mt-4">
        <li class="py-4" v-for="message in messages" :key="message.id" :message="message">
          <div class="flex items-center justify-between flex-wrap">
            <p> {{message.owner_name}}: {{message.text}}</p>
          </div>
        </li>
    </ul>

    <form action="" @submit.prevent="addMessage">
        <div class="mb-6">
          <input class="input"
            autofocus autocomplete="off"
            placeholder="Type a message"
            v-model="newMessage.text" />
        </div>
        <input type="submit" value="Send message" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
    </form>
    </div>
</template>

<script>
export default {
    name: 'Chatroom',
    data () {
        return {
        name: '',
        newMessage: [],
        messages: [],
        error: ''
        }
    },
    channels: {
        ChatChannel: {
            connected() {
                console.log("CONECTADO")
            },
            rejected() {},
            received(data) {
                if (data.message)
                    this.messages.push (data.message)
            },
            disconnected() {}
        }
    },
    created () {
        if (!localStorage.signedIn) {
        this.$router.replace('/')
        } else {
        this.$http.secured.get('/chatrooms/' + this.$route.params.name,  { name: this.$route.params.name })
            .then(response => { this.messages = response.data })
            .catch(error => this.setError(error, 'Something went wrong'))
        }
    },
    methods: {
        setError (error, text) {
        this.error = (error.response && error.response.data && error.response.data.error) || text
        },
        addMessage () {
        const value = this.newMessage
        if (!value) {
            return
        }
        this.$http.secured.post('/messages/', { message: { text: this.newMessage.text, chatroom_name: this.$route.params.name,  user_name: localStorage.user_name } })
            .then(response => {
            this.messages.push(response.data)
            this.newMessage = ''
            })
            .catch(error => this.setError(error, 'Cannot create message'))
        }
    },
    mounted() {
        this.$cable.subscribe({ channel: 'chat_' + this.$route.params.name, room: 'public' }, this.$route.params.name);
    }
}
</script>