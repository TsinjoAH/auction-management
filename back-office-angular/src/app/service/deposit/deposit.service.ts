import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {baseUrl, Response} from "../server.config";
import {Deposit} from "../../../shared/shared.interfaces";

@Injectable({
  providedIn: 'root'
})
export class DepositService {

  constructor(private http: HttpClient) { }

  fetchToEvaluate () {
    return this.http.get<Response<Deposit[]>>(baseUrl("deposits/not-validated"));
  }

  validate (id: number) {
    return this.http.put(baseUrl(`deposits/${id}/validate`), {});
  }

}
