import React, {useState} from "react";
import './CountDown.css';
import {IonBadge} from "@ionic/react";

interface CountDownProps {
    expirationDate: Date | undefined;
    onFinished: () => void;
}

export const CountDown : React.FC<CountDownProps> = ({expirationDate, onFinished}: CountDownProps) => {

    const [isFinished, finish] = useState(false);
    const [time, setTime] = useState<{[key: string]: number}>({
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0
    })

    // Update the count down every 1 second
    const interval = setInterval(() => {

        // Get today's date and time
        const now = new Date().getTime();

        // Find the distance between now and the count down date
        if (!expirationDate) {
            clearInterval(interval);
            return;
        }
        const distance = expirationDate.getTime() - now;

        // Time calculations for days, hours, minutes and seconds
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Display the result in the element
        setTime({
            days, hours, minutes, seconds
        })

        if (distance < 0) {
            clearInterval(interval);
            finish(true);
            onFinished();
        }
    }, 1000);

    return (<IonBadge color="light" className="root" >{isFinished ? "Finished" : (
        <>
            <div className="time-container" >
                {Object.keys(time).map((key, i) => {
                    return (<CountDownElt value={time[key]} text={key} key={i} />)
                })}
            </div>
        </>
    )}</IonBadge>)
}

const CountDownElt: React.FC<{value: number, text: string}> = ({value, text}) => (
    <div className="time-elt" >
        <h3>{value}</h3>
        <p>{text}</p>
    </div>
)
