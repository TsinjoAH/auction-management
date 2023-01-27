import {
    IonContent,
    IonPage, IonGrid, IonRow
} from "@ionic/react";
import React from "react";


import Menu from "../../components/menu/Menu";
import AuctionHistoricItem from "../../components/auctionList/AuctionHistoricItem";
import './AuctionList.css'
import Layout from "../../components/menu/Menu";
const AuctionHistoric: React.FC = () => {
    return (
        <Layout
            title={"Historic"}
        >
        <>
            <IonPage>
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
        </>
        </Layout>
    );
};
export default AuctionHistoric;

