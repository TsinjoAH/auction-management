import React from 'react';
import {
  IonButtons,
  IonContent,
  IonHeader,
  IonList,
  IonMenu,
  IonMenuButton,
  IonPage, IonRouterOutlet,
  IonTitle,
  IonToolbar
} from '@ionic/react';
import {Menu, MenuItem} from "./MenuItem";
import {menuItem} from "./Item";
import {Route} from "react-router-dom";
import AuctionCreation from "../../pages/auction/AuctionCreation";
import AuctionList from "../../pages/auction/AuctionList";
import AuctionHistoric from "../../pages/auction/AuctionHistoric";
import AccountRecharge from "../../pages/deposit/AccountRecharge";

function Layout(): JSX.Element {

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
              {menuItem.map((menu: Menu, index) => ( <MenuItem key={index} menu={menu} /> ))}
            </IonList>
          </IonContent>
        </IonMenu>
        <IonRouterOutlet>
          <Route path="/user/auction/new" exact={true}>
            <AuctionCreation />
          </Route>
          <Route path="/user/auctions" exact={true}>
            <AuctionList />
          </Route>
          <Route path="/user/auctions/historic" exact={true}>
            <AuctionHistoric />
          </Route>
          <Route path="/user/account/recharge" exact={true}>
            <AccountRecharge />
          </Route>
        </IonRouterOutlet>
      </>
  );
}

export default Layout;