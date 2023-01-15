interface HasId {
  id: number
}

interface HasName extends HasId{
  name: string
}

export interface Category extends HasName {}

export interface Product extends HasName{
  category: Category;
}

export interface User extends HasName{}


export interface Deposit extends HasId {
  amount: number;
  date: Date;
  user: User;
}
