import {IonItem, IonLabel, IonMenuToggle} from "@ionic/react";

export interface Menu {

    title: string,
    path: string
}

interface MenuItemProps {
    menu: Menu
}

export const MenuItem: React.FC<MenuItemProps> = ({menu}) => {
    return (
        <IonMenuToggle>
            <IonItem routerLink={menu.path} >
                <IonLabel>
                    {menu.title}
                </IonLabel>
            </IonItem>
        </IonMenuToggle>
    );
}


