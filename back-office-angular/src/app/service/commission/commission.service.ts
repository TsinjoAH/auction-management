import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {baseUrl,Response} from "../server.config";
import {Commission} from "../../../shared/shared.interfaces";
import {AuthService} from "../login/auth.service";
import {AdminService} from "../login/admin/admin.service";

@Injectable({
  providedIn: 'root'
})
export class CommissionService {

  constructor(private http: HttpClient, private authService: AdminService) { }

  fetchCurrent () {
    return this.http.get<Response<Commission>>(baseUrl("commission"), {
      headers: this.authService.headers()
    });
  }

  change(data: any) {
    return this.http.post<Response<Commission>>(baseUrl("commission"), data, {
      headers: this.authService.headers()
    });
  }

}
