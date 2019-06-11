const localhost = "127.0.0.1"
const host = "35.185.169.116"
const port = ":8081"
const ip = "http://" + localhost + port


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