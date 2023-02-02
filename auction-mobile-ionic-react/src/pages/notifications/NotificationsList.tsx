import {
    IonButtons,
    IonContent,
    IonHeader,
    IonIcon,
    IonItem, IonLabel,
    IonList,
    IonMenuButton, IonNote,
    IonPage,
    IonTitle,
    IonToolbar,
    useIonViewWillEnter
} from "@ionic/react";
import {notificationsSharp} from "ionicons/icons";
import {NotificationData} from "../../utils/shared.interfaces";
import React from "react";
import {fetchNotifications} from "../../data/notifications.service";

import './NotificationsList.css';

export const NotificationsList: React.FC = () => {

    const [notifications, setNotifications] = React.useState<NotificationData[]>([]);

    useIonViewWillEnter(() => {
        fetchNotifications().then(setNotifications);
    })

    return (
        <IonPage id="main-content">
            <IonHeader>
                <IonToolbar>
                    <IonButtons slot="start">
                        <IonMenuButton></IonMenuButton>
                    </IonButtons>
                    <IonTitle>Notifications</IonTitle>
                    <IonIcon icon={notificationsSharp} slot="end" className="notification-icon"></IonIcon>
                </IonToolbar>
            </IonHeader>
            <IonContent fullscreen>
                <IonList>
                    {notifications.map((notification, i) => (
                        <IonItem key={i} routerLink={notification.link} >
                            <IonLabel className="ion-text-wrap">
                                <h2 className="notifications">
                                    {notification.title} <br/>
                                    <span className="date">
                                        <IonNote>{new Date(notification.date).toLocaleString()}</IonNote>
                                    </span>
                                </h2>
                                <h3>
                                    {notification.content}
                                </h3>
                            </IonLabel>
                        </IonItem>
                    ))}
                </IonList>
            </IonContent>
        </IonPage>
    );
}