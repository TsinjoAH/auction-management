
const _url = "https://auction-management-production.up.railway.app/";
export const baseUrl = (url: string) => _url + url;

export interface Response<T> {
  data: T;
}
