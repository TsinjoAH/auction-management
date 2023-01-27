import React from 'react';
import {
  IonButtons,
  IonContent,
  IonHeader,
  IonList,
  IonMenu,
  IonMenuButton,
  IonPage,
  IonTitle,
  IonToolbar
} from '@ionic/react';
import {Menu, MenuItem} from "./MenuItem";
import {menuItem} from "./Item";

function Layout(props: {
  title: string,
  children: any
}): JSX.Element {

  const {children, title} = props;
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
        <IonPage id="main-content">
          <IonHeader>
            <IonToolbar>
              <IonButtons slot="start">
                <IonMenuButton></IonMenuButton>
              </IonButtons>
              <IonTitle>{title}</IonTitle>
            </IonToolbar>
          </IonHeader>
          <IonContent className="ion-padding">
            {children}
          </IonContent>
        </IonPage>
      </>
  );
}

export default Layout;