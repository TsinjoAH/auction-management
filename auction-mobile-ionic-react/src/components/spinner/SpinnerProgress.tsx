import { IonSpinner } from '@ionic/react';
import './SpinnerProgress.css';

interface SynProgressProps {
    className?: string
}

function SpinnerProgress({className}: SynProgressProps, ) {

    return (
        <div className={className}>
            <div className={" d-flex ion-justify-content-center"}>
                <IonSpinner name="bubbles" className="spinner-center"/>
            </div>
        </div>
    );
}

export default SpinnerProgress;