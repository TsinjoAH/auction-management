import {HttpClient} from "@angular/common/http";
import {baseUrl, Response} from "./server.config";
import {Category} from "../../shared/shared.interfaces";

export class CrudService<T> {

  constructor(private headers: any, private _http: HttpClient, private url: string) { }

  fetchAll() {
    return this._http.get<Response<T[]>>(baseUrl(`${this.url}`), {
      headers: this.headers
    })
  }

  create(data: any) {
    return this._http.post(baseUrl(`${this.url}`), data, {
      headers: this.headers
    });
  }

  update (id: number, data:any) {
    return this._http.put(baseUrl(`${this.url}/`+id), data, {
      headers: this.headers
    });
  }
}
