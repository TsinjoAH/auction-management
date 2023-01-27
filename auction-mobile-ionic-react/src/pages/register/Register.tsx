import {
    IonButton, IonCol, IonContent, IonGrid, IonInput, IonItem, IonLabel, IonPage, IonRouterLink, IonRow, useIonAlert
} from "@ionic/react";
import {Redirect} from "react-router-dom";

import React, {useState} from "react";
import axios from "axios";
import {serverUrl} from "../../utils/serverUrl";
import {signup} from "../../data/user.service";


const Register: React.FC = () => {

    const [username, setUsername] = useState('');
    const [email, setEmail] = useState('');
    const [pwd, setPwd] = useState('');
    const [redirect, setRedirect] = React.useState(false);
    const [clicked, setClicked] = React.useState(false);

    const [presentAlert] = useIonAlert();

    const handleUsername = (event: any) => {
        const name = event.target.value;
        setUsername(name);
    }

    const handleEmail = (event: any) => {
        const email = event.target.value;
        setEmail(email);
    }

    const handlePassword = (event: any) => {
        const password = event.target.value;
        setPwd(password);
    }

    const handleSubmit = async (event: any) => {
        setClicked(true);
        event.preventDefault();
        const userdata = {name: username, email: email, password: pwd};
        signup(userdata).then((data) => {
            setRedirect(true);
        }).catch((err) => {
            presentAlert({
                header: 'Error',
                message: err.response.data.message
            }).then(() => {
                setClicked(false);
            })
        })
    }


    return (redirect ? <Redirect to="/login"/> : <IonPage>
        <IonContent fullscreen>
            <IonGrid className="content">
                <IonRow>
                    <IonCol size="12">
                        <form className="ion-padding" onSubmit={handleSubmit}>
                            <center><h3>Sign Up</h3></center>
                            <br/>
                            <IonItem>
                                <IonLabel position="floating">Username</IonLabel>
                                <IonInput name="name" onIonChange={(e) => handleUsername(e)} required/>
                            </IonItem>
                            <IonItem>
                                <IonLabel position="floating">Email</IonLabel>
                                <IonInput name="email" type="email" onIonChange={(e) => handleEmail(e)} required/>
                            </IonItem>
                            <IonItem>
                                <IonLabel position="floating">Password</IonLabel>
                                <IonInput name="password" type="password" onIonChange={(e) => handlePassword(e)} required/>
                            </IonItem>
                            <br/>
                            <IonButton className="ion-margin-top" disabled={clicked} type="submit" expand="block">
                                Sign Up
                            </IonButton>
                        </form>
                        <center>
                            <IonRouterLink routerLink='/login'>
                                <IonLabel>
                                    Already have an account ?
                                </IonLabel>
                            </IonRouterLink>
                        </center>
                    </IonCol>
                </IonRow>
            </IonGrid>
        </IonContent>
    </IonPage>);
};
export default Register;
