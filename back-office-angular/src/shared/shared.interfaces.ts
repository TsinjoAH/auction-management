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
