import {http, serverUrl} from "../utils/serverUrl";
import {Category, Product} from "../utils/shared.interfaces";
import {getHeaders, id, User} from "./user.service";

export interface Auction {
    id: number;
    title: string;
    description: string;
    duration: number;
    startDate: Date;
    endDate: Date;
    product: Product;
    startPrice: number;
    commission: number;
    images: Pic[];
    bids: Bid[];
}

export interface Pic {
    picPath: string;
}

export interface Bid {
    amount: number;
    bidDate: Date;
    user: User;
}

export const fetchProducts = async () => {
    let result = await http.get(serverUrl("products"), {
        headers: getHeaders()
    });
    return result.data.data as Product[];
}

export const fetchCategory = async () => {
    let result = await http.get(serverUrl("categories"), {
        headers: getHeaders()
    });
    return result.data.data as Category[];
}

export const postAuction = async (auctionData: any) => {
    return  await http.post(serverUrl(`users/${id()}/auctions`), auctionData, {
        headers: getHeaders()
    });
}

export const getAuctions = async (page: number) => {
    let storage = getAuctionsInStorage();
    if (storage.length > page) {
        return storage[page];
    }
    let result = await http.get(serverUrl(`users/${id()}/auctions/pages/${page}`), {
        headers: getHeaders()
    });
    let list = result.data.data as Auction[];
    if (list.length > 0) {
        storage.push(list);
    }
    sessionStorage.setItem("auctions", JSON.stringify(storage));
    return list;
}

export const clearAuctions = () => {
    sessionStorage.removeItem("auctions");
}

const getAuctionsInStorage = () => {
    let list: any = sessionStorage.getItem("auctions");
    if (list == null) {
        sessionStorage.setItem("auctions", JSON.stringify([]));
        list = [];
    }
    else {
        list = JSON.parse(list);
    }
    return list as Auction[][];
}

export const getAuction = async (auction_id: number) => {
    let result = await http.get(serverUrl(`users/${id()}/auctions/${auction_id}`), {
        headers: getHeaders()
    });
    clearAuctions();
    return result.data.data as Auction;
}