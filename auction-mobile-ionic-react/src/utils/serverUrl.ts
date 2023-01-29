import axios from "axios";

const baseUrl = "http://192.168.88.221:8080/";
const serverUrl = (str: string):string => baseUrl + str;
const http = axios;
export {serverUrl, http}