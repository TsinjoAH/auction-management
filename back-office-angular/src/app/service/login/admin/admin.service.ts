import { Injectable } from '@angular/core';
import {AuthService} from "../auth.service";

@Injectable({
  providedIn: 'root'
})
export class AdminService extends AuthService{

  constructor() {
    super("admin", "tk");
  }

}
