import {
    IonContent,
    IonPage, IonGrid, IonRow
} from "@ionic/react";
import React from "react";


import Menu from "../../components/menu/Menu";
import AuctionHistoricItem from "../../components/auctionList/AuctionHistoricItem";
import './AuctionList.css'
const AuctionHistoric: React.FC = () => {
    return (
        <Menu
            render={() => (
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
            )}
            title={"Historic"}
        ></Menu>
    );
};
export default AuctionHistoric;

