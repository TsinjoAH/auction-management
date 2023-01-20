import {HasId} from "../../../shared/shared.interfaces";

interface Entity<T extends HasId> {
  token: string;
  entity: T
}

export class AuthService {

  constructor(
    public key: string,
    public headerKey: string
  ) { }

  isAuthenticated() {
    return (sessionStorage.getItem(this.key) != null && sessionStorage.getItem(this.headerKey) != null);
  }

  getLogged () : any {
    let json = sessionStorage.getItem(this.key);
    if (json!=null) {
      return JSON.parse(json);
    }
    return null;
  }

  getToken () {
    return sessionStorage.getItem(this.headerKey)
  }

  headers (): any{
    if(this.isAuthenticated()) {
      return {[this.headerKey]: this.getToken()};
    }
    return {}
  }

}
