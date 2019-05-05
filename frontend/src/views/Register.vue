<template>
  <v-content>
    <v-container fluid fill-height id="register-wrapper">
      <div id="register">
        <div id="login_header">
          <img v-if="pass==0" src="../assets/chicken_small.svg">
          <img v-if="pass==1" src="../assets/chicken.svg">
          <img v-if="pass==2" src="../assets/chicken_hot.svg">
          <div v-if="pass!=2">
            <h2>Register BCP</h2>
            <p>
              If you already have BCP account, click
              <router-link to="/login">sigin</router-link>
            </p>
          </div>
          <div v-else>
            <h2>You succeesfully register!</h2>
          </div>
        </div>
        <v-form v-if="pass==0" style="margin-bottom:30px;width:320px;">
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
        <v-form v-if="pass==1" style="margin-bottom:30px;width:320px;">
          <v-text-field
            v-model="register.name"
            v-validate="'required|alpha_spaces'"
            data-vv-name="name"
            :error-messages="errors.collect('name')"
            prepend-icon="account_circle"
            placeholder="Full name"
            type="text"
            color="cyan"
            class="input"
            key="reigster.name"
            required
          ></v-text-field>
          <v-text-field
            v-model="register.identification"
            v-validate="'required'"
            data-vv-name="identification"
            :error-messages="errors.collect('identification')"
            prepend-icon="credit_card"
            placeholder="身份證字號"
            color="cyan"
            class="input"
            key="reigster.identification"
            required
          ></v-text-field>
          <v-text-field
            v-model="register.birth"
            v-validate="'required|date_format:dd/MM/yyyy'"
            data-vv-name="birth"
            :error-messages="errors.collect('birth')"
            prepend-icon="cake"
            color="cyan"
            placeholder="Birth: dd/MM/yyyy"
            class="input"
            key="register.birth"
            required
          ></v-text-field>
        </v-form>
        <v-btn v-if="pass!=2" color="info" depressed @click="submit_continue">continue</v-btn>

      </div>
    </v-container>
    <v-footer style="position:absolute;bottom:0px;width:100%">
      <v-progress-linear
      v-model="progress_bar"
      color="cyan"
      height="8"
      ></v-progress-linear>
    </v-footer>
  </v-content>
</template>


<script>
export default {
  data() {
    return {
      register: {
        id: "",
        password: "",
        email: "",
        name: "",
        indentification: '',
        birth: '',
      },
      progress_bar: 33,
      pass: 0,
    };
  },
  methods: {
    success() {
      this.pass = this.pass + 1
      this.progress_bar = this.progress_bar + 33
    },
    submit_continue() {
      this.$validator.validateAll().then((valid) => {
        if(valid) {
          if(pass == 1) {
            const url = "http://127.0.0.1:8081/register/queryName";
            let obj = this.register;
            this.axios.post(url, {
            id: obj.id,
            password: obj.password,
            email: obj.email
          }).then(function (response) {
            console.log(response);
          }).catch(function (error) {
            console.log(error);
          });

          }
        }
      })
    },
  },
};
</script>

<style lang="scss">
#register-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
}

#register {
  padding: 30px;
  width: 500px;
  height: 600px;
  background-color: #424242;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  #login_header {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  img {
    margin-right: 15px;
    width: 80px;
  }

  .input {
    height: 80px;
  }
}
</style>


