<style scoped src="../../assets/styles/signup.css">
</style>

<template>
    <div id="wrapper">
        <div id="menu">
            <router-link to="/" class="signin">Sign In</router-link>
            <div style="clear:both"></div>
        </div>

        <h3 class="signuptitle">Sign Up</h3>
        <div class="error" v-if="error">{{ error }}</div>

        <form action="" @submit.prevent="signup">
            <label for="name">Use Name</label>
            <input name="username" size="50" class="input" autofocus autocomplete="off" placeholder="Name" v-model="name" />

            <label for="password">Password</label>
            <input name="password" type="password" size="50" class="input" autocomplete="off" placeholder="Password" v-model="password">

            <input type="submit" value="Sign Up" />
        </form>
    </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      name: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$http.secured.post('/signup', { name: this.name, password: this.password })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
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
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.id
      delete localStorage.access
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/chatrooms')
      }
    }
  }
}
</script>