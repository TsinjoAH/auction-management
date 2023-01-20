import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Category} from "../../../shared/shared.interfaces";
import {baseUrl} from "../server.config";
import {Response} from "../server.config";
import {CrudService} from "../crud.service";
import {AdminService} from "../login/admin/admin.service";

@Injectable({
  providedIn: 'root'
})
export class CategoryService extends CrudService<Category>{

  constructor(private http: HttpClient, private authService: AdminService) {
    super(authService.headers(), http, "categories")
  }

}
