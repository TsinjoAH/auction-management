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

const getUser = async () => {
    let result = await http.get(serverUrl("users/"+id()), {
        headers: getHeaders()
    });
    return result.data.data as User;
}


export const signup = async (data: any) => {
    let result = await axios.post(serverUrl("users"), data);
    return result.data.data;
}

const isLoggedIn = (): boolean => {
    return getToken() !== null;
}

const getToken = () => sessionStorage.getItem("user_token")

const id = () => user().id;

const user = () => JSON.parse(sessionStorage.getItem("connected_user") ?? "")as User;
const getHeaders = (): any => {tk: getToken()};

export const getRequestProps = () => {headers: getHeaders()}

export {login, isLoggedIn, getHeaders, id, user, getUser};
