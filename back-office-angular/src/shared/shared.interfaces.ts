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

export interface User extends HasName{
  email: string;
  signupDate: Date;
}


export interface Deposit extends HasId {
  amount: number;
  date: Date;
  approved: boolean
  user: User;
  approvalDate: Date
}

export interface ErrorData {
  code: number;
  message: string;
}

export interface Commission extends HasId {
  rate: number;
  setDate: Date
}

export interface IChartProps {
  data?: any;
  labels?: any;
  options?: any;
  colors?: any;
  type?: any;
  legend?: any;

  [propName: string]: any;
}


export interface StatData {
  data: number[];
  labels: string[];
  start: Date;
  end: Date;
}
