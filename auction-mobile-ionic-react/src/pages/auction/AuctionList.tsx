import {
    IonContent,
    IonPage, IonGrid, IonRow
} from "@ionic/react";
import React from "react";


import Menu from "../../components/menu/Menu";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import './AuctionList.css'
const AuctionList: React.FC = () => {
    return (
        <Menu
        render={() => (
        <>
        <IonPage>
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
        </>
        )}
        title={"My Auctions"}
        ></Menu>
    );
};
export default AuctionList;

