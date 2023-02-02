import {
    IonButton,
    IonButtons, IonCard, IonCol,
    IonContent,
    IonDatetime,
    IonDatetimeButton,
    IonGrid,
    IonHeader, IonImg,
    IonInput,
    IonItem,
    IonLabel,
    IonMenuButton,
    IonModal,
    IonPage,
    IonRow,
    IonSelect,
    IonSelectOption,
    IonTextarea,
    IonTitle,
    IonToolbar,
    useIonAlert,
    useIonViewWillEnter
} from "@ionic/react";
import React, {useRef, useState} from "react";
import {Category, Product} from "../../utils/shared.interfaces";
import {fetchCategory, fetchProducts, postAuction} from "../../data/auctions.service";
import {Autocomplete, darken, lighten, styled, TextField} from "@mui/material";
import './AuctionCreation.css';
import {Camera, CameraResultType, CameraSource} from "@capacitor/camera";
import {Crop} from "@ionic-native/crop";
import {File} from "@ionic-native/file";
import {Redirect} from "react-router-dom";

const GroupHeader = styled('div')(({theme}) => ({
    position: 'sticky',
    top: '-8px',
    padding: '4px 10px',
    color: theme.palette.primary.main,
    backgroundColor:
        theme.palette.mode === 'light'
            ? lighten(theme.palette.primary.light, 0.85)
            : darken(theme.palette.primary.main, 0.8),
}));

const GroupItems = styled('ul')({
    padding: 0,
});

const ProductModal: React.FC<{ isOpen: boolean, setOpen: (val: boolean) => void, data: (data: any) => void }> = ({isOpen,setOpen, data}) => {

    const [categories, setCategories] = useState<Category[]>([]);

    const [product, setProduct] = useState<any>({
        name: '',
        category: ''
    });

    const getCategory = (id: number) => {
        return categories.find((cat) => cat.id === id);
    }

    const modal = useRef<HTMLIonModalElement>(null);
    const [presentAlert] = useIonAlert();

    useIonViewWillEnter(() => {
        fetchCategory().then(setCategories);
    })

    const createProduct = () => {
        if (product.category && product.name) {
            product.category = getCategory(parseInt(product.category))
            data(product);
            presentAlert({
                header: "Success",
                message: "votre produit sera creer en meme temps que l'enchere"
            }).then(() => {
                setProduct({
                    name: '',
                    category: ''
                })
                setOpen(false)
            })
        } else {
            presentAlert({
                header: "Erreur",
                message: "Veuillez remplir tous les champs"
            })
        }
    }

    const handleChange = (e: any) => {
        setProduct({
            ...product,
            [e.target.name]: e.target.value
        })
    }

    return (<IonModal ref={modal} isOpen={isOpen}>
        <IonHeader>
            <IonToolbar>
                <IonTitle>Creer votre produit</IonTitle>
            </IonToolbar>
        </IonHeader>
        <IonContent className="ion-padding">
            <IonItem>
                <IonLabel position="floating">Nom du produit</IonLabel>
                <IonInput type="text" name="name" value={product.name} onIonChange={handleChange} required={true}/>
            </IonItem>
            <IonItem>
                <IonSelect name="category" value={product.category} onIonChange={handleChange}
                           placeholder="Choisir categories">
                    {categories.map((cat, index) => <IonSelectOption key={index}
                                                                     value={cat.id}>{cat.name}</IonSelectOption>)}
                </IonSelect>
            </IonItem>
            <br/>
            <IonButton expand="block" onClick={() => createProduct()}>Ajouter</IonButton>
            <IonButton expand="block" fill="outline" color="dark" onClick={() => setOpen(false)}>Annuler</IonButton>
        </IonContent>
    </IonModal>)
}

interface Image {
    name: string;
    format: string;
    base64: string;
    url: string;
}

const buildImage = (format: string, base64: string, index: number) => {
    let name = index + "."+ format;
    let img = {
        name: name,
        format: format,
        base64: base64,
        url: `data:image/${format};base64,${base64}`
    } as Image;
    return img;
}

const ImageComponent : React.FC<{img: Image}> = ({img}) => {
    const {url, name} = img;
    return (
        <IonCol size="4" className="p-0">
            <IonCard>
                <img src={url} alt={name} />
            </IonCard>
        </IonCol>
    )
}

const AuctionCreation: React.FC = () => {

    const [products, setProducts] = useState<Product[]>([]);
    const [isOpen, setOpen] = useState(false);
    const [auction, setAuction] = useState({
        title: 'Rolex',
        product: null,
        description: 'description',
        startDate: new Date(),
        duration: 120,
        startPrice: 125000
    });

    const [images, setImages] = useState<Image[]>([]);

    const [end, setEnd] = useState<Date>(new Date());

    useIonViewWillEnter(() => {
        fetchProducts().then(setProducts).catch((err) => alert(JSON.stringify(err, null, 2)));
    })

    const addOption = (data: any) => {
        setProducts([...products, data])
        setProduct(data);
    }

    const setProduct = (product: any) => {
        let val = {
            ...auction,
            product: product
        };
        console.log(val);
        setAuction(val);
    }

    const [redirect, setRedirect] = useState(false);
    const [clicked, setClicked] = useState(false);

    const handleSubmit = (e: any) => {
        e.preventDefault();
        setClicked(true);
        if (images.length === 0) {
            alert("Veuillez ajouter une image");
            setClicked(false);
        }
        else {
            let data = {
                auction: auction,
                images: images
            };
            postAuction(data).then((result) => {
                setRedirect(true);
                setClicked(false);
            }).catch((err) => {
                alert(err.response.data.message)
                setClicked(false);
            });
        }
    }

    const handleChange = (e: any) => {
        let name = e.target.name;
        let val = e.target.value;
        if (name === 'duration' || name === 'startDate') {
            if (name === 'startDate') {
                setEnd(new Date(new Date(val).getTime() + auction.duration * 60000));
            } else {
                setEnd(new Date(new Date(auction.startDate).getTime() + val * 60000));
            }
        }
        setAuction({
            ...auction,
            [name]: val
        })
    }

    const format = (d: Date) => {
        const append = (n: number) => n < 10 ? '0' + n : n;
        return d.getFullYear() + '-' + append(d.getMonth() + 1) + '-' + append(d.getDate()) + ' ' + append(d.getHours()) + ':' + append(d.getMinutes());
    }

    const pickImage = () => {
        Camera.getPhoto({
            quality: 100,
            resultType: CameraResultType.Uri,
            source: CameraSource.Photos
        }).then((data) => {
            const {format, path} = data;
            Crop.crop(path+"", {
                quality: 75
            }).then((result) => {
                let newPath = result.split('?')[0];
                let sliced = newPath.split('/');
                let imgName = sliced[sliced.length-1];
                File.readAsDataURL(newPath.split(imgName)[0], imgName).then((url) => {
                    let base64 = url.split(`data:image/${format};base64,`)[1];
                    let img = buildImage(format, base64, images.length);
                    setImages([img, ...images]);
                })
            }, error => alert(JSON.stringify(error, null, 2)))
        })
    }


    return (
        redirect ? <Redirect to="/user/auctions" /> :
        <IonPage id="main-content">
            <IonHeader>
                <IonToolbar>
                    <IonButtons slot="start">
                        <IonMenuButton></IonMenuButton>
                    </IonButtons>
                    <IonTitle>Creer une enchere</IonTitle>
                </IonToolbar>
            </IonHeader>
            <IonContent fullscreen>
                <ProductModal isOpen={isOpen} setOpen={setOpen} data={addOption}/>
                <form className="ion-padding" onSubmit={handleSubmit}>
                    <br/>

                    <IonItem fill="outline">
                        <IonLabel position="floating">Titre</IonLabel>
                        <IonInput name="title" value={auction.title}  onIonChange={handleChange} type="text" required />
                    </IonItem>

                    <Autocomplete
                        className="mt"
                        options={products}
                        getOptionLabel={(option: Product) => option.name}
                        onChange={(e, v) => setProduct(v)}
                        value={auction.product}
                        groupBy={option => option.category.name}
                        renderInput={params => <TextField {...params} label="choisissez un produit" required variant="outlined" />}
                        renderGroup={params => (
                            <li key={params.key}>
                                <GroupHeader>{params.group}</GroupHeader>
                                <GroupItems>{params.children}</GroupItems>
                            </li>
                        )}
                        noOptionsText={<IonButton expand="block" fill="clear" color="primary" onClick={() => setOpen(true)}>Create new product</IonButton>}
                    />

                    <IonItem fill="outline" className="mt">
                        <IonLabel position="floating">Description</IonLabel>
                        <IonTextarea
                            name="description"
                            placeholder="Type something here"
                            autoGrow={true}
                            value={auction.description}
                            onIonChange={handleChange} required
                        ></IonTextarea>
                    </IonItem>

                    <IonItem className="mt" fill="outline">
                        <IonLabel>Debut</IonLabel>
                        <IonDatetimeButton datetime="datetime"></IonDatetimeButton>
                        <IonModal keepContentsMounted={true}>
                            <IonDatetime name="startDate" onIonChange={handleChange} locale="EAT" id="datetime"></IonDatetime>
                        </IonModal>
                    </IonItem>

                    <IonItem fill="outline" className="mt">
                        <IonLabel position="floating">Duration (minutes) </IonLabel>
                        <IonInput type="number" name="duration" onIonChange={handleChange} required/>
                    </IonItem>

                    <IonItem className="mt" fill="outline">
                        <IonLabel>Date fin</IonLabel>
                        <IonInput disabled={true} type="datetime-local" value={format(end)}/>
                    </IonItem>

                    <IonItem className="mt" fill="outline">
                        <IonLabel position="floating">Prix de depart</IonLabel>
                        <IonInput name="startPrice" value={auction.startPrice} type="number" onIonChange={handleChange} required/>
                    </IonItem>

                    <IonGrid className="p-0">
                        <IonRow className="p-0">
                            {images.map((img, i) => <ImageComponent img={img} key={i} /> )}
                            <IonCol className="p-0" size="4" onClick={() => pickImage()}>
                                <IonCard className="add-image" >
                                    <div>
                                        <img src="/assets/add-image.svg" alt="add-image"/>
                                    </div>
                                </IonCard>
                            </IonCol>
                        </IonRow>
                    </IonGrid>

                    <br/>
                    <IonButton className="ion-margin-top" disabled={clicked} type="submit" expand="block">
                        Creer
                    </IonButton>
                </form>
            </IonContent>
        </IonPage>
    );
};

export default AuctionCreation;
