import {http, serverUrl} from "../utils/serverUrl";
import {Deposit} from "../pages/deposit/DepositItem";
import {id} from "./user.service";

export const makeDeposit = async (amount: number) => {
    let result = await http.post(serverUrl(`users/${id()}/deposits`), {
        amount: amount
    });
    return result.data.data as Deposit;
}

export const fetchDepositHistory = async (page: number) => {
    let result = await http.get(serverUrl(`users/${id()}/deposits`));
    return result.data.data as Deposit[];
}

