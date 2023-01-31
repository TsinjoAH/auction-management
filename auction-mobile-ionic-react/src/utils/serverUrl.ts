import axios from "axios";

const baseUrl = "http://localhost:8080/";
const serverUrl = (str: string):string => baseUrl + str;
export {serverUrl}