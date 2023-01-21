import { IonItem, IonList } from "@ionic/react";
import React from "react";
import {AuctionListItem} from "../autionListItem/AuctionListItem";

interface AuctionListProps {
}

const AuctionList: React.FC<AuctionListProps> = ({}) => {

    return (
        <IonList>
            <AuctionListItem/>
                <IonItem>
                    No Auction Found
                </IonItem>
        </IonList>
    );
};

export default AuctionList;
