import { IonApp, IonRouterOutlet, IonSplitPane, setupIonicReact } from '@ionic/react';
import { IonReactRouter } from '@ionic/react-router';
import { Redirect, Route } from 'react-router-dom';

/* Core CSS required for Ionic components to work properly */
import '@ionic/react/css/core.css';

/* Basic CSS for apps built with Ionic */
import '@ionic/react/css/normalize.css';
import '@ionic/react/css/structure.css';
import '@ionic/react/css/typography.css';

/* Optional CSS utils that can be commented out */
import '@ionic/react/css/padding.css';
import '@ionic/react/css/float-elements.css';
import '@ionic/react/css/text-alignment.css';
import '@ionic/react/css/text-transformation.css';
import '@ionic/react/css/flex-utils.css';
import '@ionic/react/css/display.css';

/* Theme variables */
import './theme/variables.css';
import Register from './pages/register/Register';
import {Login} from "./pages/login/Login";
import Layout from "./components/menu/Layout";
import {AuctionProfile} from "./pages/auction/auctionProfile/AuctionProfile";
import {useEffect} from "react";
import {ActionPerformed, PushNotifications, PushNotificationSchema, Token} from "@capacitor/push-notifications";
import {isLoggedIn, registerDevice} from "./data/user.service";

setupIonicReact();

const App: React.FC = () => {

  return (
    <IonApp>
      <IonReactRouter>
        <IonSplitPane contentId="main">
          <IonRouterOutlet id="main">
            <Route path="/" exact={true}>
              <Redirect to={isLoggedIn() ? "/user/auctions" : "login"} />
            </Route>
            <Route path="/register" exact={true}>
              <Register />
            </Route>
            <Route path="/login" exact={true}>
              <Login />
            </Route>
            <Route path="/user/**" exact={true} >
              <Layout></Layout>
            </Route>
            <Route path="/auctions/:id" >
              <AuctionProfile></AuctionProfile>
            </Route>
          </IonRouterOutlet>
        </IonSplitPane>
      </IonReactRouter>
    </IonApp>
  );
};

export default App;
