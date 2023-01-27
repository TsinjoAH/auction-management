import axios from "axios";

const baseUrl = "http://localhost:8080/";
const serverUrl = (str: string):string => baseUrl + str;
const http = axios;
export {serverUrl, http}