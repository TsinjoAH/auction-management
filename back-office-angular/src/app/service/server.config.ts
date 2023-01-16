
const _url = "http://localhost:8080/";
export const baseUrl = (url: string) => _url + url;

export interface Response<T> {
  data: T;
}
