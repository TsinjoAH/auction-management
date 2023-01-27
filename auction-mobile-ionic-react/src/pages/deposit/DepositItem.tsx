import React, {useState} from "react";
import {IonBadge, IonItem, IonLabel, IonNote} from "@ionic/react";

export interface Deposit {
    id: number;
    amount: number;
    statusChangeDate?: Date;
    status: number;
    date: Date
}

interface Status {
    text: string;
    color: string;
}

export const DepositItem: React.FC<{ deposit: Deposit }> = ({deposit}) => {

    const getStatus = (deposit: Deposit) => {
        let statusList: {[propName: string]: Status} = {
            "0": {
                color: "primary",
                text: "En cours"
            },
            "10": {
                color: "danger",
                text: "Rejete"
            },
            "20": {
                color: "success",
                text: "OK"
            }
        }
        return statusList[deposit.status.toString()];
    }

    const [status, setStatus] = useState<Status>(getStatus(deposit))

    return (
        <IonItem detail={false}>
            <IonLabel className="ion-text-wrap">
                <h2>
                    {deposit.amount.toLocaleString()} ar
                </h2>
                <p>
                    {new Date(deposit.date).toDateString()}
                </p>
            </IonLabel>
            <IonBadge color={status.color}>{status.text}</IonBadge>
        </IonItem>
    );
}
