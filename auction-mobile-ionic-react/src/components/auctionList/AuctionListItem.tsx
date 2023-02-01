import React, {useState} from 'react';
import {IonBadge, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonCol} from '@ionic/react';
import './AuctionListItem.css';
import {CountDown} from "../timer/CountDown";
import {serverUrl} from "../../utils/serverUrl";
import {Auction} from "../../data/auctions.service";



export const AuctionTimer: React.FC<{auction: Auction}> = ({auction}) => {
    const getProperties = () => {
        let now = new Date().getTime();
        let start = new Date(auction.startDate).getTime();
        let end = new Date(auction.endDate).getTime();
        let props = {
            now, start, end
        }
        return props;
    }
    const getStatus = () => {
        const {now, start, end} = getProperties();
        if (now < start) {
            return 0;
        }
        if (now < end) {
            return 1;
        }
        return 2;
    }

    const getTimerDate = () => {
        const {now, start, end} = getProperties();
        const dateList = [new Date(start), new Date(end), new Date()]
        return dateList[getStatus()];
    }
    const getStatusText = () => {
        let text = statusList[getStatus()];
        return text;
    };

    const [expirationDate, setExpirationDate] = useState<Date>(getTimerDate());
    const statusList = ["Will begin after", "Will end after", ""];
    const [status, setStatus] = useState<string>(getStatusText());

    const onFinished = () => {
        let newEnd = getTimerDate();
        if (newEnd.getTime() === expirationDate?.getTime()) return;
        setExpirationDate(newEnd);
        setStatus(getStatusText);
    }

    return (
        <>
            <IonBadge>{status}</IonBadge>
            <CountDown expirationDate={expirationDate} onFinished={onFinished}/>
        </>
    )
}


const AuctionListItem: React.FC<{ auction: Auction }> = ({auction}) => {


    return (
        <IonCol sizeMd="3" sizeSm="6" size="12">
            <IonCard className="card" routerLink={`/auctions/`+auction.id}>
                <img alt="auction" src={serverUrl(auction.images[0].picPath)}/>
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