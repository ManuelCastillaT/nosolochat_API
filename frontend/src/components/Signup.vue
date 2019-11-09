<template>
  <div class="max-w-sm m-auto my-8">
    <div class="border p-10 border-grey-light shadow rounded">
      <h3 class="text-2xl mb-6 text-grey-darkest">Sign Up</h3>
      <form @submit.prevent="signup">
        <div class="text-red" v-if="error">{{ error }}</div>

        <div class="mb-6">
          <label for="name" class="label">User Name</label>
          <input type="name" v-model="name" class="input" id="name" placeholder="Name">
        </div>

        <div class="mb-6">
          <label for="password" class="label">Password</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>

        <button type="submit" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center">Sign Up</button>
      </form>
    </div>
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
      if (!response.data.login) {
        this.signupFailed(response)
        return
      }
      localStorage.csrf = response.data.login.csrf
      localStorage.access = response.data.login.access
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/chatrooms')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
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