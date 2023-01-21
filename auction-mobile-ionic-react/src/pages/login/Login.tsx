import { IonBackButton, IonButton, IonButtons, IonContent, IonHeader, IonInput, IonItem, IonLabel, IonModal, IonPage, IonRouterLink, IonToolbar } from "@ionic/react";

const Login: React.FC = () => {
    return (
        <IonPage>
            <IonContent fullscreen>
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
            </IonContent>
        </IonPage>
    );    
};
export default Login;
