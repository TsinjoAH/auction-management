import {
    IonButton, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonContent, IonInput,
    IonItem,
    IonLabel,
    IonList, IonPage, useIonAlert, useIonViewWillEnter
} from "@ionic/react";
import React, { useState } from "react";
import { ModalLoader } from "../../components/modal-loader/ModalLoader";
import { PageHeader } from "../../components/PageHeader";
import { fetchDepositHistory, makeDeposit } from "../../data/deposits.service";
import { getUser, User } from "../../data/user.service";
import './AuctionRecharge.css';
import { Deposit, DepositItem } from "./DepositItem";

const AccountRecharge: React.FC = () => {

    const [deposits, setDeposits] = useState<Deposit[]>([]);
    const [value, setValue] = useState<number>(0);
    const [clicked, setClicked] = useState(false);
    const [presentAlert] = useIonAlert();
    const [page, setPage] = useState(0);
    const [next, setNext] = useState(false);

    const [user, setUser] = useState<User>();
    const [onload, load] = useState<boolean>(false);

    useIonViewWillEnter(() => {
        load(true)
        fetchNextPage();
        getUser().then((user) => {
            setUser(user)
            load(false);
        });
    })

    const fetchNextPage = () => {
        setNext(true);
        fetchDepositHistory(page).then((data) => {
            if (data.length == 0 && page > 0)
                alert("Vos historiques sont tous deja present!");
            if (data.length > 0) {
                if (page > 0) {
                    deposits.push(...data);
                    setDeposits(deposits);
                }
                else {
                    setDeposits(data);
                }
                setPage(page + 1);
            }
            setNext(false);
        });
    }

    const handleChange = (event: any) => {
        setValue(parseInt(event.target.value));
    }

    const handleSubmit = (e: any) => {
        e.preventDefault();
        setClicked(true);
        if (value > 0) {
            makeDeposit(value).then((deposit) => {
                let list = [];
                list.push(deposit, ...deposits);
                setDeposits(list);
                setValue(0);
                presentAlert({
                    header: "Success",
                    message: "Demande de depot success"
                }).then(() => {
                    setClicked(false);
                })
            })
            .catch((error) => {
                presentAlert({
                    header: "Erreur",
                    message: error.response.data.message
                }).then(() => {
                    setClicked(false)
                })
            })
        }
        else {
            setClicked(false)
        }
    }

    return (
        <IonPage id="main-content">
            <PageHeader title={"Mon compte"} />
            <IonContent fullscreen>
                <ModalLoader isOpen={onload} />
                <IonCard color="light" >
                    <IonCardTitle className="ion-padding">
                        {user?.name} <br />
                        <small>{user?.email}</small>
                    </IonCardTitle>
                </IonCard>
                <IonCard color="success">
                    <IonCardTitle className="ion-padding balance" >
                        <span>Balance</span>
                        <span>{user?.balance.toLocaleString()} Ar</span>
                    </IonCardTitle>
                </IonCard>
                <IonCard>
                    <IonCardTitle className="ion-padding pb-0" >
                        Faire une recharge
                    </IonCardTitle>
                    <IonCardContent>
                        <form onSubmit={handleSubmit} >
                            <IonItem>
                                <IonLabel position="floating">Montant</IonLabel>
                                <IonInput name="amount" value={value} type="number" min="0" onIonChange={handleChange} />
                            </IonItem>
                            <IonButton disabled={clicked} className="ion-margin-top" type="submit" expand="block">
                                Envoyer la demande
                            </IonButton>
                        </form>
                    </IonCardContent>
                </IonCard>
                <IonCard>
                    <IonCardHeader>
                        <IonCardTitle>Historiques depots</IonCardTitle>
                    </IonCardHeader>
                    <IonCardContent>
                        <IonList>
                            {deposits.map((deposit, key) => <DepositItem deposit={deposit} key={key} />)}
                        </IonList>
                        <IonButton disabled={next} fill="clear" expand="block" onClick={() => fetchNextPage()} >Voir plus</IonButton>
                    </IonCardContent>
                </IonCard>
            </IonContent>
        </IonPage>
    );
};


export default AccountRecharge;
