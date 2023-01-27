import {
    IonButton,
    IonCol,
    IonContent,
    IonGrid,
    IonInput,
    IonItem,
    IonLabel,
    IonPage,
    IonRow,
    IonSelect,
    IonSelectOption,
    IonTextarea,
    useIonAlert
} from "@ionic/react";
import React, {useState} from "react";
import Menu from "../../components/menu/Menu";
import Layout from "../../components/menu/Menu";

function addField(){
    const ionGrid = document.getElementById('grid');
    const ionRow = document.createElement('IonRow');
    const ionCol = document.createElement('IonCol');
    ionCol.setAttribute('size','12');
    const ionItem = document.createElement('IonItem');
    const field = document.createElement('input');
    field.setAttribute('type','file');
    field.setAttribute('name','photo');
    field.setAttribute('className','d-none');
    field.setAttribute('id','input-file');
    ionItem.appendChild(field);
    ionCol.appendChild(ionItem);
    ionRow.appendChild(ionCol);
    ionGrid?.appendChild(ionRow);
}

const AuctionCreation: React.FC = () => {

    const [preview, setPreview] = useState<any>();
    const [presentAlert] = useIonAlert();


    const setImage = (e: any) => {
        let file = e.target.files![0];
        let name = file.name;
        let extensions = ['.jpg', '.jpeg', '.png'];
        let accept = false;
        for (let ext of extensions) {
            if (name.endsWith(ext)) {
                accept = true;
                break;
            }
        }
        if (!accept) {
            presentAlert({
                header: 'Veuillez selectionnez des images',
                message: 'Les images doivent être au format .jpg, .jpeg ou .png',
                buttons: ['OK']
            }).then(() => {
                setPreview(undefined);
            });
            return;
        }
        let reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => {
            setPreview(reader.result);
        }
    }

    return (
    <Layout
        title={"Create Auction"}
    >
        <>
            <IonPage>
                <IonContent fullscreen>
                    <form className="ion-padding">
                        <br/>
                        <IonGrid id="grid">
                            <IonRow>
                                <IonCol size="12">
                                    <IonItem>
                                        <IonLabel position="stacked">Title</IonLabel>
                                        <IonInput name="title"/>
                                    </IonItem>
                                </IonCol>
                                <IonCol size="12">
                                    <IonItem>
                                        <IonLabel position="stacked">Description</IonLabel>
                                        <IonTextarea name="description" rows={4}/>
                                    </IonItem>
                                </IonCol>
                            </IonRow>
                            <IonRow>
                                <IonCol size="8">
                                    <IonItem>
                                        <IonLabel position="stacked">Start Date</IonLabel>
                                        <IonInput type="datetime-local" name="start-date"/>
                                    </IonItem>
                                </IonCol>
                                <IonCol size="4">
                                    <IonItem>
                                        <IonLabel position="stacked">Duration</IonLabel>
                                        <IonInput type="number" name="duration"/>
                                    </IonItem>
                                </IonCol>
                            </IonRow>
                            <IonRow>
                                <IonCol size="8">
                                    <IonItem>
                                        <IonLabel position="stacked">Product</IonLabel>
                                        <IonSelect name="product">
                                            *                                        <IonSelectOption value="1">Cars</IonSelectOption>
                                            <IonSelectOption value="2">Clothes</IonSelectOption>
                                        </IonSelect>
                                    </IonItem>
                                </IonCol>
                                <IonCol size="4">
                                    <IonItem>
                                        <IonLabel position="stacked">Start Price</IonLabel>
                                        <IonInput type="number" name="start-price" style={{
                                        }}
                                        />
                                    </IonItem>
                                </IonCol>
                            </IonRow>
                            <IonRow>
                                <IonCol size="12">
                                    <IonItem>
                                        <input id="input-file" type="file" className="d-none" onChange={setImage} />
                                        <br/><br/>
                                        { preview ? <img className="img-preview" src={preview} width="35%" alt=""/>  : "" }
                                    </IonItem>
                                    <IonRow>
                                        <IonCol size="1">
                                        </IonCol>
                                    </IonRow>
                                </IonCol>
                            </IonRow>
                            <IonRow>
                            </IonRow>

                        </IonGrid>
                        <IonRow>
                            <IonCol size="1">
                                <IonButton id="addField" onClick={addField} className="ion-margin-top" expand="block" fill="outline">
                                    +
                                </IonButton>
                            </IonCol>
                        </IonRow>
                        <br/>
                        <IonButton className="ion-margin-top" type="submit" expand="block">
                            Save
                        </IonButton>
                    </form>
                </IonContent>
            </IonPage>
        </>
    </Layout>
    );
};
export default AuctionCreation;
