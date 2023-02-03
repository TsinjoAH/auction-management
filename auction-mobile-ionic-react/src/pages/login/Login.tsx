import {
    IonBackButton, IonButton, IonCol, IonContent, IonGrid, IonInput, IonItem, IonLabel, IonPage, IonRow, useIonAlert,
} from "@ionic/react";

import './Login.css';
import React, {useRef} from "react";
import {login, LoginInfo} from "../../data/user.service";
import {Redirect} from "react-router-dom";


export const Login: React.FC = () => {
    const modal = useRef<HTMLIonModalElement>(null);

    const [presentAlert] = useIonAlert();

    const [data, updateData] = React.useState({
        email: 'lahatra@gmail.com', password: 'gemmedecristal'
    });

    const [redirect, setRedirect] = React.useState(false);
    const [clicked, setClicked] = React.useState(false);

    const handleSubmit = (e: any) => {
        setClicked(true)
        e.preventDefault();
        modal.current?.present();
        login(data).then(() => {setRedirect(true)}).catch((error) => {
            presentAlert({
                header: 'Error', message: error.response.data.message
            }).then(() => {
                setClicked(false);
            })
        });
    }

    const handleChange = (event: any) => {
        updateData({
            ...data, [event.target.name]: event.target.value
        });
    }

    return (redirect ? <Redirect to="/user/auctions"/> : <IonPage>
        <IonContent>
            <IonGrid className="content">
                <IonRow>
                    <IonCol size="12">
                        <form className="ion-padding" onSubmit={handleSubmit}>
                            <center><h3>Log In</h3></center>
                            <br/>
                            <IonItem>
                                <IonLabel position="floating">Email</IonLabel>
                                <IonInput type="email" value={data.email} name="email" onIonChange={handleChange}/>
                            </IonItem>
                            <IonItem>
                                <IonLabel position="floating">Password</IonLabel>
                                <IonInput name="password" value={data.password} type="password"
                                          onIonChange={handleChange}/>
                            </IonItem>
                            <br/>
                            <IonButton disabled={clicked} className="ion-margin-top" type="submit" expand="block">
                                Log In
                            </IonButton>
                        </form>
                        <center>
                            <br/>
                            <IonBackButton text="Don't have an account ?" defaultHref="/register"></IonBackButton>
                        </center>
                    </IonCol>
                </IonRow>
            </IonGrid>
        </IonContent>
    </IonPage>);
};
