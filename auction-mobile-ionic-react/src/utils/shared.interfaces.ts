
export interface HasId {
    id: number;
}

export interface HasName extends HasId{
    name: string
}

export interface Category extends HasName{

}

export interface Product extends HasName{
    category: Category
}

export interface NotificationData {
    title: string,
    content: string,
    link: string,
    image: string,
    user: string,
    date: Date
}
