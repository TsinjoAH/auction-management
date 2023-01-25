import React from 'react';
import { IonCard, IonCardContent, IonCardHeader, IonCardSubtitle, IonCardTitle ,IonCol} from '@ionic/react';
import './AuctionListItem.css';


function AuctionListItem() {
    const countDownDate = new Date("Jan 25, 2023 22:47:25").getTime();

// Update the count down every 1 second
    const x = setInterval(function () {

        // Get today's date and time
        const now = new Date().getTime();

        // Find the distance between now and the count down date
        const distance = countDownDate - now;
        const timer = document.getElementById("timer");

        // Time calculations for days, hours, minutes and seconds
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Display the result in the element with id="demo"
        if (timer != null) {
            timer.innerHTML = days + "d " + hours + "h "
                + minutes + "m " + seconds + "s ";

            // If the count down is finished, write some text
            if (distance < 0) {
                clearInterval(x);
                timer.innerHTML = "FINISHED";
            }
        }
    }, 1000);
    return (
        <IonCol sizeMd="3" sizeSm="6" size="12">
        <IonCard className="card">
            <img alt="Silhouette of mountains" src="https://ionicframework.com/docs/img/demos/card-media.png"/>
            <IonCardHeader>
                <IonCardTitle>Auction Title</IonCardTitle>
                <IonCardSubtitle>Auction Status</IonCardSubtitle>
                <p id="timer"></p>
            </IonCardHeader>
            <IonCardContent>
                Here's a small text description for the card content. Nothing more, nothing less.
            </IonCardContent>
        </IonCard>
        </IonCol>
    );
}
export default AuctionListItem;