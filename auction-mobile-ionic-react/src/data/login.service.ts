import axios from "axios";
import {serverUrl} from "../utils/serverUrl";

const http = axios;

export interface LoginInfo {
    token: string
}

const login = (data: any, success: () => any, error: (message: string) => any ) => {
    console.log(data);
    http.post(serverUrl("users/login"), data).then((res) => {
        sessionStorage.setItem("tk", res.data.data.token);
        success();
    }).catch((err) => {
        error(err.response.data.error.message);
    });
}

const isLoggedIn = (): boolean => {
    return sessionStorage.getItem("tk") !== null;
}

const getHeaders = (): any => {tk: sessionStorage.getItem("tk")};

export {login, isLoggedIn, getHeaders};