interface HasId {
  id: number
}
interface HasName extends HasId{
  name: string
}
export interface Category extends HasName {}
