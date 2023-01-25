import {
    IonBackButton,
    IonButton,
    IonCol,
    IonContent,
    IonGrid,
    IonInput,
    IonItem,
    IonLabel,
    IonPage,
    IonRow, useIonAlert,
} from "@ionic/react";

import './Login.css';
import React, {useRef} from "react";
import {login} from "../../data/login.service";
import {Redirect} from "react-router-dom";




    const Login: React.FC = () => {
        const modal = useRef<HTMLIonModalElement>(null);

        const [presentAlert] = useIonAlert();

        const [data, updateData] = React.useState({
            email: '',
            password: ''
        });

        const [redirect, setRedirect] = React.useState(false);

        const handleSubmit = (e: any) => {
            e.preventDefault();
            modal.current?.present();
            login(data, () => {
                console.log('login success');
                setRedirect(true);
            }, (m) => {
                    presentAlert({
                        header: 'Error',
                        message: m
                    }).then(r => console.log('error'))
            });
        }

        const handleChange = (event: any) => {
            updateData({
                ...data,
                [event.target.name]: event.target.value
            });
        }
        return (
            redirect ?
            <Redirect to="/auctions" /> :
            <IonPage>
                <IonContent>
                    <IonGrid className="content">
                        <IonRow>
                            <IonCol size="12">
                                <form className="ion-padding" onSubmit={handleSubmit}>
                                    <center><h3>Log In</h3></center>
                                    <br/>
                                    <IonItem>
                                        <IonLabel position="floating">Email</IonLabel>
                                        <IonInput type="email" name="email" onIonChange={handleChange}/>
                                    </IonItem>
                                    <IonItem>
                                        <IonLabel position="floating">Password</IonLabel>
                                        <IonInput name="password" type="password" onIonChange={handleChange}/>
                                    </IonItem>
                                    <br/>
                                    <IonButton className="ion-margin-top" type="submit" expand="block">
                                        Log In
                                    </IonButton>
                                </form>
                                <center>
                                    <br/>
                                    <IonBackButton text="Don't have an account ?" defaultHref="/"></IonBackButton>
                                </center>
                            </IonCol>
                        </IonRow>
                    </IonGrid>
                </IonContent>
            </IonPage>
        );
    };
    export default Login;
