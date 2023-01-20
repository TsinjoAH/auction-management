import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {baseUrl, Response} from "../server.config";
import {Deposit} from "../../../shared/shared.interfaces";
import {AdminService} from "../login/admin/admin.service";

@Injectable({
  providedIn: 'root'
})
export class DepositService {

  constructor(private http: HttpClient, private authService: AdminService) { }

  fetchToEvaluate () {
    return this.http.get<Response<Deposit[]>>(baseUrl("deposits/not-validated"), {
      headers: this.authService.headers()
    });
  }

  validate (id: number) {
    return this.http.put(baseUrl(`deposits/${id}/validate`), {}, {
      headers: this.authService.headers()
    });
  }

  reject(id: number) {
    return this.http.put(baseUrl(`deposits/${id}/reject`), {}, {
      headers: this.authService.headers()
    });
  }
}
