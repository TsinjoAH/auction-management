import React, {useEffect, useState} from "react";
import {useParams} from "react-router";
import {
    IonBadge,
    IonCard,
    IonCardContent, IonCardTitle,
    IonContent,
    IonIcon, IonItem, IonLabel, IonList,
    IonPage,
    IonSlide,
    IonSlides, IonTitle,
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
import {CountDown} from "../../../components/timer/CountDown";
import {AuctionTimer} from "../../../components/auctionList/AuctionListItem";


export const AuctionProfile: React.FC = () => {

    const params = useParams<{ id: string }>();
    const [auction, setAuction] = useState<Auction>();
    const [redirect, setRedirect] = useState<boolean>();

    useIonViewWillEnter(() => {
        setRedirect(false);
    })

    useEffect(() => {
        getAuction(parseInt(params.id)).then((data) => {
            console.log(data);
            setAuction(data);
        });
    }, [params.id])

    return (
        redirect ? <Redirect to={"/user/auctions"} /> :
        <IonPage>
            <IonContent fullscreen>
                <div>
                    <div>
                        <IonIcon onClick={() => setRedirect(true)} className="back-icon" slot="start" icon={arrowBack}></IonIcon>
                    </div>
                    <h2>{auction?.title}</h2>
                    <div className="slider">
                        <Swiper
                            modules={[Pagination]}
                            pagination={true}
                        >
                            {auction?.images.map((img, i) =>
                                <SwiperSlide key={i} >
                                    <img src={serverUrl(img.picPath)} alt="" className="img-100"/>
                                </SwiperSlide>
                            )}
                        </Swiper>
                    </div>

                    <div className="">
                        <IonCard>
                            <IonCardTitle className="ion-padding" >
                                Informations generales
                            </IonCardTitle>
                            <IonCardContent className="pt-0" >
                                <p><u>Produit</u>: {auction?.product.name}</p>
                                <p><u>Category</u>: {auction?.product.category.name}</p>
                                <p><u>Description</u>: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Alias atque aut esse, eum, fugiat illo laborum neque, nesciunt nisi nostrum placeat qui quidem quisquam. Animi cum dolorem eligendi iusto quia?</p>
                            </IonCardContent>
                        </IonCard>
                    </div>
                    <IonCard>
                        <IonCardContent>
                            {auction ? <AuctionTimer auction={auction} /> : ""}
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
                                </IonItem>) : ""}
                            </IonList>
                        </IonCardContent>
                    </IonCard>
                </div>
            </IonContent>
        </IonPage>
    )
}

