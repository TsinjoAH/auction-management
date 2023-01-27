import {
    IonContent,
    IonPage, IonGrid, IonRow
} from "@ionic/react";
import React from "react";


import Menu from "../../components/menu/Menu";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import './AuctionList.css'
import Layout from "../../components/menu/Menu";
const AuctionList: React.FC = () => {
    return (
        <Layout title={"My Auctions"} >
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
        </Layout>
    );
};
export default AuctionList;

