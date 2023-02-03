import {
    IonButton, IonContent,
    IonGrid, IonPage,
    IonRow, useIonViewWillEnter
} from "@ionic/react";
import React, { useState } from "react";
import AuctionListItem from "../../components/auctionList/AuctionListItem";
import { ModalLoader } from "../../components/modal-loader/ModalLoader";
import { PageHeader } from "../../components/PageHeader";
import { Auction, getAuctions } from "../../data/auctions.service";
import './AuctionList.css';

const AuctionList: React.FC = () => {

    const [auctions, setAuctions] = useState<Auction[]>([]);
    const [page, setPage] = useState<number>(0);
    const [clicked, setClicked] = useState<boolean>(false);
    const [onload, load] = useState<boolean>(false);

    useIonViewWillEnter(() => {
        fetchNextPage();
    });

    const fetchNextPage = ()  => {
        setClicked(true);
        load(true)
        if (page === 0) {
            getAuctions(page).then((data) => {
                setAuctions(data);
                stopLoading();
            });
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
                stopLoading();
            });
        }
    }

    const stopLoading = () => {
        load(false);
    }

    return (
        <IonPage id="main-content">
            <PageHeader title={"Mes encheres" } />
            <IonContent className="content">
                <ModalLoader isOpen={onload}/>
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