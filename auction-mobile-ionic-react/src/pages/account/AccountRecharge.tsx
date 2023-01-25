import {IonButton, IonCol, IonContent, IonGrid, IonInput, IonItem, IonLabel, IonPage, IonRow,} from "@ionic/react";
import React from "react";
import Menu from "../../components/menu/Menu";

const AccountRecharge: React.FC = () => {
    return (
    <Menu
        render={() => (
        <>
        <IonPage>
            <center>
            <IonContent fullscreen>
                <IonGrid className="content">
                    <IonRow>
                        <IonCol size="12">
                <form className="ion-padding">
                    <center><h3>Recharge your account</h3></center>
                    <br/>
                    <IonItem>
                        <IonLabel position="floating">Amount</IonLabel>
                        <IonInput name="number"/>
                    </IonItem>
                    <br/>
                    <IonButton className="ion-margin-top" type="submit" expand="block">
                        Save
                    </IonButton>
                </form>
                        </IonCol>
                    </IonRow>
                </IonGrid>
            </IonContent>
            </center>
        </IonPage>
        </>
        )}
        title={"Account Recharge"}
    ></Menu>
    );
};
export default AccountRecharge;
