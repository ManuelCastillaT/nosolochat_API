<template>
  <div class="max-w-sm m-auto my-8">
    <div class="border p-10 border-grey-light shadow rounded">
      <h3 class="text-2xl mb-6 text-grey-darkest">Sign In</h3>
      <form @submit.prevent="signin">
        <div class="text-red" v-if="error">{{ error }}</div>

        <div class="mb-6">
          <label for="name" class="label">Use Name</label>
          <input type="name" v-model="name" class="input" id="name" placeholder="Name">
        </div>
        <div class="mb-6">
          <label for="password" class="label">Password</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>
        <button type="submit" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center">Sign In</button>
      </form>
    </div>
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
      if (!response.data.login) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.login.csrf
      localStorage.access = response.data.login.access
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/chatrooms')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
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