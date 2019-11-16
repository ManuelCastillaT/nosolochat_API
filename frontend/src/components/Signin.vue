<style scoped src="../../assets/styles/signin.css">
</style>

<template>
    <div id="wrapper">
        <div id="menu">
            <router-link to="/signup" class="signup">Sign Up</router-link>
            <div style="clear:both"></div>
        </div>

        <h3 class="signintitle">Sign In</h3>
        <div class="error" v-if="error">{{ error }}</div>

        <form action="" @submit.prevent="signin">
            <label for="name">Use Name</label>
            <input name="username" size="50" class="input" autofocus placeholder="Name" v-model="name" />

            <label for="password">Password</label>
            <input name="password" type="password" size="50" class="input" id="password" autocomplete="off" placeholder="Password" v-model="password">

            <input type="submit" value="Sign In" />
        </form>
    </div>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      name: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin', { name: this.name, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.login || !response.data.token_id) {
        this.signinFailed(response)
        return
      }
      localStorage.id = response.data.token_id
      localStorage.csrf = response.data.login.csrf
      localStorage.access = response.data.login.access
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/chatrooms')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.id
      delete localStorage.access
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/chatrooms')
      }
    }
  }
}
</script>