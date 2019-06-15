<template>
  <div style="display:flex; flex-direction:column; align-item:center; justify-conter:center">
    <v-form style="margin-bottom:30px;width:320px;">
      <v-text-field
        v-model="register.id"
        v-validate="'required|alpha_num|'"
        data-vv-name="id"
        :error-messages="errors.collect('id')"
        prepend-icon="person"
        name="login"
        placeholder="BCP ID"
        type="text"
        color="cyan"
        class="input"
        required
      ></v-text-field>
      <v-text-field
        v-model="register.password"
        v-validate="'required|min:6'"
        data-vv-name="password"
        :error-messages="errors.collect('password')"
        prepend-icon="lock"
        name="password"
        placeholder="Password"
        type="password"
        color="cyan"
        class="input"
        required
      ></v-text-field>
      <v-text-field
        v-model="register.email"
        v-validate="'required|email'"
        data-vv-name="email"
        :error-messages="errors.collect('email')"
        prepend-icon="email"
        color="cyan"
        placeholder="Email"
        class="input"
        required
      ></v-text-field>
    </v-form>
    <div style="display:flex; justify-content:center">
      <p id="error_message"></p>
    </div>
    <v-btn color="info" depressed @click="submit">continue</v-btn>
  </div>
</template>


<script>
import URL from "../parameter/ip"
export default {
  name: "RegisterName",
  data() {
    return {
      register: {
        id: "",
        password: "",
        email: ""
      },
    };
  },
  methods: {
    submit() {
      this.$validator.validateAll().then(valid => {
        if (valid) {
          console.log("post queryName");
          const url = URL.register.queryName
          let obj = this.register;
          this.axios
            .post(url, obj)
            .then(response => {
              if (response.data.status === "OK") {
                console.log("You can continue");
                this.$emit('triggerSuccess', obj)
              } else {
                const error_message = response.data.status
                document.getElementById('error_message').innerHTML = error_message
              }
            })
            .catch(error => {
              console.log(error);
            });
        }
      });
    }
  }
};
</script>

<style lang="scss">
#error_message {
  color: #FD5151;
}
</style>

