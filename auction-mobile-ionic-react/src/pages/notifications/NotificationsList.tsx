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
import React, { useState } from "react";
import {fetchNotifications} from "../../data/notifications.service";

import './NotificationsList.css';
import { PageHeader } from "../../components/PageHeader";
import { ModalLoader } from "../../components/modal-loader/ModalLoader";

export const NotificationsList: React.FC = () => {

    const [notifications, setNotifications] = React.useState<NotificationData[]>([]);
    const [onload, load] = useState<boolean>(false);

    useIonViewWillEnter(() => {
        load(true);
        fetchNotifications().then((data) => {
            setNotifications(data);
            load(false);
        });
    })

    return (
        <IonPage id="main-content">
           <PageHeader title={"Notifications"} />
            <IonContent fullscreen>
                <ModalLoader isOpen={onload} />
                <IonList>
                    {notifications.map((notification, i) => (
                        <IonItem key={i} routerLink={notification.link} >
                            <IonLabel className="ion-text-wrap">
                                <h2 className="notifications">
                                    {notification.title} <br/>
                                    <span className="date">
                                        <IonNote>
                                            {new Date(notification.date).toLocaleString()}
                                        </IonNote>
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
