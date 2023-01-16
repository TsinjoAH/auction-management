import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {baseUrl,Response} from "../server.config";
import {Commission} from "../../../shared/shared.interfaces";

@Injectable({
  providedIn: 'root'
})
export class CommissionService {

  constructor(private http: HttpClient) { }

  fetchCurrent () {
    return this.http.get<Response<Commission>>(baseUrl("commission"));
  }

  change(data: any) {
    return this.http.post<Response<Commission>>(baseUrl("commission"), data);
  }

}
