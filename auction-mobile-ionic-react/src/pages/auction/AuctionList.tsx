import {
    IonButton,
    IonButtons,
    IonContent,
    IonGrid,
    IonHeader, IonIcon,
    IonMenuButton,
    IonPage,
    IonRow,
    IonTitle,
    IonToolbar, useIonViewWillEnter
} from "@ionic/react";
import React, {useState} from "react";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import './AuctionList.css'
import {Auction, getAuctions} from "../../data/auctions.service";
import {barbellSharp, notifications, notificationsSharp} from "ionicons/icons";
import {PageHeader} from "../../components/PageHeader";

const AuctionList: React.FC = () => {

    const [auctions, setAuctions] = useState<Auction[]>([]);
    const [page, setPage] = useState<number>(0);
    const [clicked, setClicked] = useState<boolean>(false);

    useIonViewWillEnter(() => {
        fetchNextPage();
    });

    const fetchNextPage = ()  => {
        setClicked(true);
        if (page === 0) {
            getAuctions(page).then(setAuctions);
            setPage(page + 1)
            setClicked(false);
        }
        else {
            getAuctions(page).then((data) => {
                if (data.length === 0) {
                    alert("Ce sont tous vos enchere");
                }
                else {
                    setPage(page + 1)
                    setAuctions([...auctions, ...data]);
                }
                setClicked(false);
            });
        }
    }

    return (
        <IonPage id="main-content">
            <PageHeader title={"Mes encheres" } />
            <IonContent className="content">
                <IonGrid>
                    <IonRow>
                        {auctions.map((auction, i) => {
                            return ( <AuctionListItem key={i} auction={auction} /> )
                        })}
                    </IonRow>
                </IonGrid>
                <IonButton disabled={clicked} onClick={() => fetchNextPage()} expand="block" fill="clear" >Voir plus</IonButton>
                <br/>
            </IonContent>
        </IonPage>
    );
};

export default AuctionList;