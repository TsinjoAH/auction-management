import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import Login from './views/login/Login';
import Register from './views/register/Register';
import Home from './views/home/Home';


import reportWebVitals from './reportWebVitals';import {
    BrowserRouter, Routes, Route, useNavigate
} from "react-router-dom";
import AuctionList from "./views/auction/AuctionList";
import Historic from "./views/auction/Historic";
import AuctionProfil from "./views/auction/AuctionProfil";
import AboutUs from "./views/about/AboutUs";

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <BrowserRouter>
    <Routes>
        <Route path={'/'} element={<Home/>} ></Route>
        <Route path={'/register'} element={<Register/>} ></Route>
        <Route path={'/login'} element={<Login/>} ></Route>
        <Route path={'/auctions'} element={<AuctionList/>} ></Route>
        <Route path={'/history'} element={<Historic/>} ></Route>
        <Route path={'/profile'} element={<AuctionProfil/>} ></Route>
        <Route path={'/about'} element={<AboutUs/>} ></Route>
    </Routes>
  </BrowserRouter>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
