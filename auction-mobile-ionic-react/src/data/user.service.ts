import axios, {AxiosError} from "axios";
import {serverUrl} from "../utils/serverUrl";
import {Deposit} from "../pages/deposit/DepositItem";

const http = axios;

export interface User {
    id: number,
    name: string,
    email: string,
    signupDate: Date,
    balance: number
}

export interface LoginInfo {
    token: string,
    entity: User
}

const login = async (data: any) => {
    let result = await http.post(serverUrl("users/login"), data);
    let info = result.data.data as LoginInfo;
    sessionStorage.setItem("user_token", info.token);
    sessionStorage.setItem("connected_user", JSON.stringify(info.entity));
}

class registering {
    static key = "registered";
    static set = () => sessionStorage.setItem(registering.key, "true");
    static get = () => sessionStorage.getItem(registering.key) === "true";
}

const registerDevice = async (token: string) => {
    let result = await http.put(serverUrl(`users/${id()}/devices`), {
        deviceToken: token
    }, {
        headers: getHeaders()
    });
    registering.set();
    return result.data.data
}

const getUser = async () => {
    let result = await http.get(serverUrl("users/"+id()), {
        headers: getHeaders()
    });
    return result.data.data as User;
}


export const signup = async (data: any) => {
    let result = await axios.post(serverUrl("users/signup"), data);
    return result.data.data;
}

const isLoggedIn = (): boolean => {
    return getToken() !== null;
}

const getToken = () => {
    return sessionStorage.getItem("user_token")
}

const id = () => user().id;

const user = () => {
    return JSON.parse(sessionStorage.getItem("connected_user") ?? "") as User
};

const getHeaders = (): any => {
    return {"tk": getToken()}
};

export const getRequestProps = () => {headers: getHeaders()}

export {login, isLoggedIn, getHeaders, id, user, getUser, registerDevice, registering};
