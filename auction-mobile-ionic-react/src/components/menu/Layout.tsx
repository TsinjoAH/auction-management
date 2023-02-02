import React, {useEffect} from 'react';
import {IonContent, IonHeader, IonList, IonMenu, IonRouterOutlet, IonTitle, IonToolbar} from '@ionic/react';
import {Menu, MenuItem} from "./MenuItem";
import {menuItem} from "./Item";
import {Route} from "react-router-dom";
import AuctionCreation from "../../pages/auction/AuctionCreation";
import AuctionList from "../../pages/auction/AuctionList";
import AuctionHistoric from "../../pages/auction/AuctionHistoric";
import AccountRecharge from "../../pages/deposit/AccountRecharge";
import {ActionPerformed, PushNotifications, PushNotificationSchema, Token} from "@capacitor/push-notifications";
import {registerDevice} from "../../data/user.service";

function Layout(): JSX.Element {

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
    }, [])

    const register = () => {
        console.log('Initializing HomePage');

        // Register with Apple / Google to receive push via APNS/FCM
        PushNotifications.register();

        // On success, we should be able to receive notifications
        PushNotifications.addListener('registration',
            (token: Token) => {
                registerDevice(token.value).then(() => {
                   alert('Push registration success');
                })
            }
        );

        // Some issue with our setup and push will not work
        PushNotifications.addListener('registrationError',
            (error: any) => {
                alert('Error on registration: ' + JSON.stringify(error));
            }
        );

        // Show us the notification payload if the app is open on our device
        PushNotifications.addListener('pushNotificationReceived',
            (notification: PushNotificationSchema) => {
                // setnotifications(notifications => [...notifications, { id: notification.id, title: notification.title, body: notification.body, type: 'foreground' }])
            }
        );

        // Method called when tapping on a notification
        PushNotifications.addListener('pushNotificationActionPerformed',
            (notification: ActionPerformed) => {
                // setnotifications(notifications => [...notifications, { id: notification.notification.data.id, title: notification.notification.data.title, body: notification.notification.data.body, type: 'action' }])
            }
        );
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
                <Route path="/user/auctions/historic" exact={true}>
                    <AuctionHistoric/>
                </Route>
                <Route path="/user/account/recharge" exact={true}>
                    <AccountRecharge/>
                </Route>
            </IonRouterOutlet>
        </>
    );
}

export default Layout;