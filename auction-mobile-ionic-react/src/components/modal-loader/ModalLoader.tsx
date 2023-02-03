import {
    IonModal
} from '@ionic/react';
import React from "react";
import SpinnerProgress from '../spinner/SpinnerProgress';
import './ModalLoader.css';

export const ModalLoader: React.FC<{isOpen: boolean}> = ({isOpen}) => {
    return (
        <IonModal className="modal" isOpen={isOpen} >
            <SpinnerProgress className="vertical-center" />
        </IonModal>
    )
}