import {
    IonButton, IonButtons, IonCard, IonCardContent, IonCardHeader, IonCardTitle,
    IonCol,
    IonContent,
    IonGrid, IonHeader,
    IonInput,
    IonItem,
    IonLabel,
    IonList, IonMenuButton,
    IonPage,
    IonRow, IonTitle, IonToolbar, useIonAlert, useIonViewWillEnter,
} from "@ionic/react";
import React, {useState} from "react";
import Layout from "../../components/menu/Menu";
import {Deposit, DepositItem} from "./DepositItem";
import {login} from "../../data/user.service";
import {fetchDepositHistory, makeDeposit} from "../../data/deposits.service";


const AccountRecharge: React.FC = () => {

    const [deposits, setDeposits] = useState<Deposit[]>([]);
    const [value, setValue] = useState<number>(0);
    const [clicked, setClicked] = useState(false);
    const [presentAlert] = useIonAlert();
    const [page, setPage] = useState(0);
    const [next, setNext] = useState(false);

    useIonViewWillEnter(() => {
        fetchNextPage();
    })

    const fetchNextPage = () => {
        setNext(true);
        fetchDepositHistory(page).then((data) => {
            if (data.length > 0) {
                if (page > 0) {
                    deposits.push(...data);
                    setDeposits(deposits);
                }
                else  {
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
            }).catch((error) => {
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
            <IonHeader>
                <IonToolbar>
                    <IonButtons slot="start">
                        <IonMenuButton></IonMenuButton>
                    </IonButtons>
                    <IonTitle>Creer une enchere</IonTitle>
                </IonToolbar>
            </IonHeader>
                <IonContent fullscreen>
                    <form className="ion-padding" onSubmit={handleSubmit} >
                        <IonItem>
                            <IonLabel position="floating">Montant</IonLabel>
                            <IonInput name="amount" value={value} type="number" min="0" onIonChange={handleChange}/>
                        </IonItem>
                        <IonButton disabled={clicked} className="ion-margin-top" type="submit" expand="block">
                            Envoyer la demande
                        </IonButton>
                    </form>
                    <IonCard>
                        <IonCardHeader>
                            <IonCardTitle>Historiques</IonCardTitle>
                        </IonCardHeader>
                        <IonCardContent>
                            <IonList>
                                {deposits.map((deposit, key) => <DepositItem deposit={deposit} key={key} /> )}
                            </IonList>
                            <IonButton disabled={next} fill="clear" expand="block" onClick={() => fetchNextPage()} >Voir plus</IonButton>
                        </IonCardContent>
                    </IonCard>
                </IonContent>
    </IonPage>
    );
};


export default AccountRecharge;
