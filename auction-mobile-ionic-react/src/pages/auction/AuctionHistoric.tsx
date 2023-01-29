import {
    IonContent,
    IonPage, IonGrid, IonRow, IonHeader, IonToolbar, IonButtons, IonMenuButton, IonTitle
} from "@ionic/react";
import React from "react";


import Menu from "../../components/menu/Menu";
import AuctionHistoricItem from "../../components/auctionList/AuctionHistoricItem";
import './AuctionList.css'
import Layout from "../../components/menu/Menu";
const AuctionHistoric: React.FC = () => {
    return (
        <IonPage id="main-content">
            <IonHeader>
                <IonToolbar>
                    <IonButtons slot="start">
                        <IonMenuButton></IonMenuButton>
                    </IonButtons>
                    <IonTitle>Creer une enchere</IonTitle>
                </IonToolbar>
            </IonHeader>
                <IonContent className="content">
                    <IonGrid>
                        <IonRow>
                            <AuctionHistoricItem/>
                            <AuctionHistoricItem/>
                            <AuctionHistoricItem/>
                            <AuctionHistoricItem/>
                        </IonRow>
                    </IonGrid>
                </IonContent>
            </IonPage>
    );
};
export default AuctionHistoric;

