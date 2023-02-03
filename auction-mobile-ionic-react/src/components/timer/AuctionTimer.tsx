import React, {useState} from "react";
import {Auction} from "../../data/auctions.service";
import {IonBadge} from "@ionic/react";
import {CountDown} from "./CountDown";

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
