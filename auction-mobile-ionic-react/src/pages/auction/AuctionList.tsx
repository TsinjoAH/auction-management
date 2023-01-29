import {
    IonButtons,
    IonContent,
    IonGrid,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonRow,
    IonTitle,
    IonToolbar
} from "@ionic/react";
import React from "react";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import './AuctionList.css'

const AuctionList: React.FC = () => {
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
                        <AuctionListItem/>
                        <AuctionListItem/>
                        <AuctionListItem/>
                        <AuctionListItem/>
                    </IonRow>
                </IonGrid>
            </IonContent>
        </IonPage>
    );
};
export default AuctionList;

