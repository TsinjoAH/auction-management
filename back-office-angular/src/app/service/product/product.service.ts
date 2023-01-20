import { Injectable } from '@angular/core';
import {CrudService} from "../crud.service";
import {Product} from "../../../shared/shared.interfaces";
import {HttpClient} from "@angular/common/http";
import {AdminService} from "../login/admin/admin.service";

@Injectable({
  providedIn: 'root'
})
export class ProductService extends CrudService<Product>{

  constructor(private http: HttpClient, private authService: AdminService) {
    super(authService.headers(),http, "products");
  }

}
