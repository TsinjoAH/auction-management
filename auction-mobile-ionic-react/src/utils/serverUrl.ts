import axios from "axios";

const baseUrl = "https://auction-management-production-a966.up.railway.app/";
const serverUrl = (str: string):string => baseUrl + str;
const http = axios;
export {serverUrl, http}
