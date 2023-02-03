import React, {useState} from 'react';
import {IonBadge, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonCol} from '@ionic/react';
import './AuctionListItem.css';
import {CountDown} from "../timer/CountDown";
import {serverUrl} from "../../utils/serverUrl";
import {Auction} from "../../data/auctions.service";
import {AuctionTimer} from "../timer/AuctionTimer";

const AuctionListItem: React.FC<{ auction: Auction }> = ({auction}) => {


    return (
        <IonCol sizeMd="3" sizeSm="6" size="12">
            <IonCard className="card" routerLink={`/auctions/`+auction.id}>
                <img alt="auction" className="img-100" src={serverUrl(auction.images[0].picPath)}/>
                <IonBadge className="price" color="success"><h2>2000 ar</h2></IonBadge>
                <IonCardHeader>
                    <IonCardTitle>
                        {auction.title}
                    </IonCardTitle>
                </IonCardHeader>
                <IonCardContent>
                    <AuctionTimer auction={auction} />
                </IonCardContent>
            </IonCard>
        </IonCol>
    );
}


export default AuctionListItem;