import React, {useEffect, useState} from "react";
import {useParams} from "react-router";
import {
    IonCard,
    IonCardContent,
    IonCardTitle,
    IonContent,
    IonIcon,
    IonItem,
    IonLabel,
    IonList,
    IonPage,
    useIonViewWillEnter
} from "@ionic/react";
import {Auction, getAuction} from "../../../data/auctions.service";
import {arrowBack} from "ionicons/icons";
import './AuctionProfile.css';
import {serverUrl} from "../../../utils/serverUrl";
import {Redirect} from "react-router-dom";
import {Swiper, SwiperSlide} from "swiper/react";

import 'swiper/swiper.min.css';
import '@ionic/react/css/ionic-swiper.css';
import './pagination.css';
import {Pagination} from "swiper";
import {AuctionTimer} from "../../../components/timer/AuctionTimer";
import { ModalLoader } from "../../../components/modal-loader/ModalLoader";


export const AuctionProfile: React.FC = () => {

    const [auction, setAuction] = useState<Auction>();
    const [redirect, setRedirect] = useState<boolean>(false);
    const [onload, load] = useState<boolean>(false);
    const { id } = useParams<{ id: string }>();

    useIonViewWillEnter(() => {
        setRedirect(false)
        load(true)
        getAuction(parseInt(id)).then((data) => {
            load(false);
            setAuction(data);
        });
    }, [id])


    return (
        redirect ? <Redirect to={"/user/auctions"}/> :
            <IonPage>
                <IonContent fullscreen>
                    <ModalLoader isOpen={onload} />
                    <div>
                        <div>
                            <IonIcon onClick={() => setRedirect(true)} className="back-icon" slot="start"
                                     icon={arrowBack}></IonIcon>
                        </div>
                        <h2>{auction?.title}</h2>
                        <div className="slider">
                            <Swiper
                                modules={[Pagination]}
                                pagination={true}
                            >
                                {auction?.images.map((img, i) =>
                                    <SwiperSlide key={i}>
                                        <img src={serverUrl(img.picPath)} alt="" className="img-100"/>
                                    </SwiperSlide>
                                )}
                            </Swiper>
                        </div>

                        <div >
                            <IonCard>
                                <IonCardTitle className="ion-padding">
                                    Informations generales
                                </IonCardTitle>
                                <IonCardContent className="pt-0">
                                    <p><u>Produit</u>: {auction?.product.name}</p>
                                    <p><u>Category</u>: {auction?.product.category.name}</p>
                                    <p><u>Description</u>: {auction?.description}</p>
                                </IonCardContent>
                            </IonCard>
                        </div>
                        <IonCard>
                            <IonCardContent>
                                {auction ? <AuctionTimer auction={auction}/> : <></>}
                            </IonCardContent>
                        </IonCard>
                        <IonCard>
                            <IonCardTitle className="ion-padding">
                                Liste des propositions
                            </IonCardTitle>
                            <IonCardContent className="pt-0">
                                <IonList className="pt-0">
                                    {auction?.bids.map((bid, i) => (
                                        <IonItem key={i}>
                                            <IonLabel>{bid.user.name}</IonLabel>
                                            <span>{bid.amount} Ar</span>
                                        </IonItem>
                                    ))}
                                    {auction?.bids.length == 0 ? (<IonItem>
                                        Aucune
                                    </IonItem>) : <></>}
                                </IonList>
                            </IonCardContent>
                        </IonCard>
                    </div>
                </IonContent>
            </IonPage>
    )

}

