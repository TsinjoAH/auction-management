import {IonButton, IonButtons, IonHeader, IonIcon, IonMenuButton, IonMenuToggle, IonTitle, IonToolbar, useIonRouter} from "@ionic/react";
import {notificationsSharp} from "ionicons/icons";
import React from "react";

export const PageHeader: React.FC<{title: string}> = ({title}) => {

    const router = useIonRouter();

    return (
        <IonHeader>
            <IonToolbar>
                <IonButtons slot="start">
                    <IonMenuButton></IonMenuButton>
                </IonButtons>
                <IonTitle>{title}</IonTitle>
                <IonButtons slot="end">
                    <IonButton routerLink="/user/notifications" >
                        <IonIcon icon={notificationsSharp} slot="end" className="notification-icon" ></IonIcon>
                    </IonButton>
                </IonButtons>
            </IonToolbar>
        </IonHeader>
    );
}
