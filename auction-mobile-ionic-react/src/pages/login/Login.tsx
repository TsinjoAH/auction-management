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
    IonRow,
} from "@ionic/react";

import './Login.css';
import React from "react";

const Login: React.FC = () => {
    return (
        <IonPage>
            <IonContent>
                <IonGrid className="content">
                    <IonRow>
                        <IonCol size="12">
                            <form className="ion-padding">
                            <center><h3>Log In</h3></center>
                            <br/>
                                <IonItem>
                                    <IonLabel position="floating">Email</IonLabel>
                                    <IonInput name="email"/>
                                </IonItem>
                                <IonItem>
                                    <IonLabel position="floating">Password</IonLabel>
                                    <IonInput name="password" type="password" />
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
