<style scoped src="../../assets/styles/chatroom.css">
</style>

<template>
    <div id="wrapper">
        <div id="menu">
            <p class="chatname">{{ this.$route.params.name }} <b></b></p>
            <router-link to="/chatrooms" class="index">Chatrooms</router-link>
            <div style="clear:both"></div>
        </div>
      
        <div id="chatbox">
            <div v-for="message in messages" :key="message.id" :message="message">
                <p> {{message.owner_name}}: {{message.text}}</p>
            </div>
        </div>

        <form action="" @submit.prevent="addMessage">
            <input name="usermsg"  size="63" class="input" autofocus autocomplete="off" placeholder="Type a message" v-model="newMessage.text" />
            <input type="submit" value="Send message" />
        </form>
    </div>
</template>

<script>
import ActionCable from "actioncable";

export default {
    name: 'Chatroom',
    data () {
        return {
        name: '',
        newMessage: [],
        messages: [],
        error: '',
        cable: []
        }
    },
    created () {
        if (!localStorage.signedIn) {
            this.$router.replace('/')
        } 
        else {
            this.$http.secured.get('/chatrooms/' + this.$route.params.name,  { name: this.$route.params.name })
                .then(response => { this.messages = response.data })
                .catch(error => this.setError(error, 'Something went wrong'))

            this.cable = ActionCable.createConsumer("ws://localhost:3000/cable?token=" + localStorage.id);

            this.cable.subscriptions.create({ channel: "RoomChannel", chatroom_name: this.$route.params.name } ,
            {
                received: this.received
            });
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
            this.$http.secured.post('/messages/', { message: { text: this.newMessage.text, chatroom_name: this.$route.params.name } })
                .then(response => {
                this.newMessage = []
                })
                .catch(error => this.setError(error, 'Cannot create message'))
        },
        received(data) {
            if (data)
                this.messages.push(data)

            if (this.messages.length >= 20 )
                this.messages.shift()
        }
    }
}
</script>