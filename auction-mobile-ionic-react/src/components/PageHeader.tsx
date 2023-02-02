import {IonButtons, IonHeader, IonIcon, IonMenuButton, IonTitle, IonToolbar, useIonRouter} from "@ionic/react";
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
                <IonIcon onClick={() => router.push("/user/notifications")} icon={notificationsSharp} slot="end" className="notification-icon" ></IonIcon>
            </IonToolbar>
        </IonHeader>
    );
}
