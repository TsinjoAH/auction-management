import React, {useEffect} from 'react';
import {
    IonContent,
    IonHeader,
    IonList,
    IonMenu,
    IonRouterOutlet,
    IonTitle,
    IonToolbar,
    useIonRouter
} from '@ionic/react';
import {Menu, MenuItem} from "./MenuItem";
import {menuItem} from "./Item";
import {Route} from "react-router-dom";
import AuctionCreation from "../../pages/auction/AuctionCreation";
import AuctionList from "../../pages/auction/AuctionList";
import AccountRecharge from "../../pages/deposit/AccountRecharge";
import {ActionPerformed, PushNotifications, PushNotificationSchema, Token} from "@capacitor/push-notifications";
import {registerDevice, registering} from "../../data/user.service";
import {NotificationData} from "../../utils/shared.interfaces";
import {LocalNotifications} from "@capacitor/local-notifications";

import './Layout.css';
import {NotificationsList} from "../../pages/notifications/NotificationsList";

function Layout(): JSX.Element {

    const router = useIonRouter();

    useEffect(() => {
            PushNotifications.checkPermissions().then((res) => {
                if (res.receive !== 'granted') {
                    PushNotifications.requestPermissions().then((res) => {
                        if (res.receive === 'denied') {
                            alert('Push Notification permission denied');
                        }
                        else {
                            alert('Push Notification permission granted');
                            register();
                        }
                    });
                }
                else {
                    register();
                }
            });
    }, []);

    const register = () => {
        console.log('Initializing HomePage');

        // Register with Apple / Google to receive push via APNS/FCM
        PushNotifications.register();

        // On success, we should be able to receive notifications
        PushNotifications.addListener('registration',
            (token: Token) => {
                registerDevice(token.value).then(() => {
                   console.log("-- registration success --");
                })
            }
        );

        // Some issue with our setup and push will not work
        PushNotifications.addListener('registrationError',
            (error: any) => {
                alert('Error on registration: ' + JSON.stringify(error));
            }
        );

        let index = 1;

        // Show us the notification payload if the app is open on our device
        PushNotifications.addListener('pushNotificationReceived',
            (notification: any) => {
                let data : NotificationData = notification.data;
                console.log(data.image);
                LocalNotifications.schedule({
                    notifications: [
                        {
                            id: index,
                            title: data.title,
                            body: data.content,
                            attachments: [
                                {
                                    id: '1',
                                    url: data.image,
                                }
                            ],
                            extra: data
                        }
                    ]
                }).then(r => {
                    console.log(r, " Notification received");
                    index++;
                })
            }
        );

        // Method called when tapping on a notification
        PushNotifications.addListener('pushNotificationActionPerformed',
            (notification: ActionPerformed) => {
                let data : NotificationData = notification.notification.data;
                router.push(data.link);
            }
        );

        LocalNotifications.addListener('localNotificationActionPerformed', (notification) => {
            let data : NotificationData = notification.notification.extra;
            router.push(data.link);
        });
    }

    return (
        <>
            <IonMenu contentId="main-content">
                <IonHeader>
                    <IonToolbar>
                        <IonTitle>Auction</IonTitle>
                    </IonToolbar>
                </IonHeader>
                <IonContent className="ion-padding">
                    <IonList>
                        {menuItem.map((menu: Menu, index) => (<MenuItem key={index} menu={menu}/>))}
                    </IonList>
                </IonContent>
            </IonMenu>
            <IonRouterOutlet>
                <Route path="/user/auction/new" exact={true}>
                    <AuctionCreation/>
                </Route>
                <Route path="/user/auctions" exact={true}>
                    <AuctionList/>
                </Route>
                <Route path="/user/account/recharge" exact={true}>
                    <AccountRecharge/>
                </Route>
                <Route path="/user/notifications" exact={true}>
                    <NotificationsList />
                </Route>
            </IonRouterOutlet>
        </>
    );
}

export default Layout;