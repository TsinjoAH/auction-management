import {http, serverUrl} from "../utils/serverUrl";
import {getHeaders, id} from "./user.service";
import {NotificationData} from "../utils/shared.interfaces";


export const fetchNotifications = async () => {
    let result = await http.get(serverUrl(`users/${id()}/notifications`), {
        headers: getHeaders()
    });
    return result.data.data as NotificationData[];
}
