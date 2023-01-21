import { IonItem, IonLabel } from "@ionic/react";
import React from "react";

interface AuctionListItemProps {
}

export const AuctionListItem: React.FC<AuctionListItemProps> = ({  }) => {
    return (
        <IonItem>
            <div slot="start" className="dot dot-unread"></div>
            <IonLabel className="ion-text-wrap">
                <h2>
                    Auction Title
                </h2>
            </IonLabel>
        </IonItem>
    );
}
