import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import Login from './views/login/Login';
import Register from './views/register/Register';
import Home from './views/home/Home';


import reportWebVitals from './reportWebVitals';import  {
  BrowserRouter,Routes,Route
  } from "react-router-dom";  


const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <BrowserRouter>
    <Routes>
    <Route path={'/'} element={<Login/>} ></Route>
    <Route path={'/register'} element={<Register/>} ></Route>
    <Route path={'/home'} element={<Home/>} ></Route>
    </Routes>
  </BrowserRouter>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
