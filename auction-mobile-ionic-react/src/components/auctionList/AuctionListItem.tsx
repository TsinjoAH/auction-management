import React from 'react';
import { IonCard, IonCardContent, IonCardHeader, IonCardSubtitle, IonCardTitle ,IonCol} from '@ionic/react';
import './AuctionListItem.css';


function AuctionListItem() {
    return (
        <IonCol sizeMd="3" sizeSm="6" size="12">
        <IonCard className="card">
            <img alt="Silhouette of mountains" src="https://ionicframework.com/docs/img/demos/card-media.png" />
            <IonCardHeader>
                <IonCardTitle>Auction Title</IonCardTitle>
                <IonCardSubtitle>Auction Status</IonCardSubtitle>
            </IonCardHeader>
            <IonCardContent>
                Here's a small text description for the card content. Nothing more, nothing less.
            </IonCardContent>
        </IonCard>
        </IonCol>
    );
}
export default AuctionListItem;