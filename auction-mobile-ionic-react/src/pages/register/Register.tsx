import { IonBackButton, IonButton, IonButtons,
    IonCol, IonContent, IonGrid, IonHeader, IonInput, IonItem, IonLabel, IonModal, IonPage, IonRouterLink,
    IonRow, IonToolbar } from "@ionic/react";

const Register: React.FC = () => {
    return (
        <IonPage>
            <IonContent fullscreen>
                <IonGrid className="content">
                    <IonRow>
                        <IonCol size="12">
                <form className="ion-padding">
                <center><h3>Sign Up</h3></center>
                <br/>
                    <IonItem>
                        <IonLabel position="floating">Username</IonLabel>
                        <IonInput name="name"/>
                    </IonItem>
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
        </IonPage>
    );    
};
export default Register;
