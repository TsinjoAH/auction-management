import { Injectable } from '@angular/core';
import {CrudService} from "../crud.service";
import {Product} from "../../../shared/shared.interfaces";
import {HttpClient} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class ProductService extends CrudService<Product>{

  constructor(private http: HttpClient) {
    super(http, "products");
  }

}
