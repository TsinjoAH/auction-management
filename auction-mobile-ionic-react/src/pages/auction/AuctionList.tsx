import {
    IonContent,
    IonGrid,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonRow,
    IonTitle,
    IonToolbar, useIonViewWillEnter
} from "@ionic/react";
import React, {useState} from "react";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import './AuctionList.css'
import {Auction, getAuctions} from "../../data/auctions.service";

const AuctionList: React.FC = () => {

    const [auctions, setAuctions] = useState<Auction[]>([]);

    useIonViewWillEnter(() => {
        getAuctions().then(setAuctions);
    });

    return (
        <IonPage id="main-content">
            <IonHeader>
                <IonToolbar>
                    <IonButtons slot="start">
                        <IonMenuButton></IonMenuButton>
                    </IonButtons>
                    <IonTitle>Liste de vos encheres</IonTitle>
                </IonToolbar>
            </IonHeader>
            <IonContent className="content">
                <IonGrid>
                    <IonRow>
                        {auctions.map((auction, i) => {
                            return ( <AuctionListItem key={i} auction={auction} /> )
                        })}
                    </IonRow>
                </IonGrid>
            </IonContent>
        </IonPage>
        </>
        )}
        title={"My Auctions"}
        ></Menu>
    );
};
export default AuctionList;

