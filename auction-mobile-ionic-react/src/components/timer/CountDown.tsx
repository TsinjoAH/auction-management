import React, {useState} from "react";

interface CountDownProps {
    expirationDate: Date
}

export const CountDown : React.FC<CountDownProps> = ({expirationDate}: CountDownProps) => {

    const [text, setText] = useState("");

    // Update the count down every 1 second
    const interval = setInterval(() => {

        // Get today's date and time
        const now = new Date().getTime();

        // Find the distance between now and the count down date
        const distance = expirationDate.getTime() - now;

        // Time calculations for days, hours, minutes and seconds
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Display the result in the element
        setText(days + "d " + hours + "h " + minutes + "m " + seconds + "s ");

        if (distance < 0) {
            clearInterval(interval);
            setText("FINISHED")
        }
    }, 1000);

    return (<p>{text}</p>)
}