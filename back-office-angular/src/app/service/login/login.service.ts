import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {baseUrl, Response} from "../server.config";

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient) { }

  login (data: any) {
    return this.http.post<Response<any>>(baseUrl("admin/login"), data);
  }

}
