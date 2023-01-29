import {http, serverUrl} from "../utils/serverUrl";
import {Category, Product} from "../utils/shared.interfaces";

export const fetchProducts = async () => {
    let result = await http.get(serverUrl("products"));
    return result.data.data as Product[];
}

export const fetchCategory = async () => {
    let result = await http.get(serverUrl("categories"));
    return result.data.data as Category[];
}
