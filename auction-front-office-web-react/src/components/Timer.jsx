import React, {useState} from "react";

interface TimerProps {
    expirationDate: Date
}

export const Timer : React.FC<TimerProps> = ({expirationDate}: TimerProps) => {

    const [text, setText] = useState("");

    // Update the count down every 1 second
    const interval = setInterval(() => {

        // Get today's date and time
        const now = new Date().getTime();

        // Find the distance between now and the count down date
        const distance = expirationDate - now;

        // Time calculations for days, hours, minutes and seconds
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Display the result in the element
        if (distance < 0) {
            clearInterval(interval);
            setText("FINISHED")
        }else{
            setText(days + "d " + hours + "h " + minutes + "m " + seconds + "s ");
        }
    }, 1000);

    return (<p>{text}</p>)
}