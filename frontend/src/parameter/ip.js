const localhost = "127.0.0.1"
const host = "bcpplatform.hopto.org"
const port = ":80"
const ip = "https://" + host


export default {
    auth:     ip + "/auth",
    register: {
        register: ip + "/register/register",
        queryName: ip + "/register/queryName"
    },
    launch: {
        propose: ip + "/launch/propose",
    },
    login: ip + "/login",


}
