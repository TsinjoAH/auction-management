import {Component, useEffect, useState} from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import AuctionListItem from "../../components/AuctionListItem";
import AdvancedSearch from "../../components/AdvancedSearch";
import global from "../../global.json";
import {Navigate} from "react-router-dom";

export default function Historic(props){
        const [data,setData]=useState([]);
        const [connected,setConnected]=useState(true);
        useEffect(()=>{
            let user=JSON.parse(localStorage.getItem("user"));
            if(user===null){
                alert("please log to see historic, thanks ");
                setConnected(false);
            }else{
                fetch(global.link+"/users/"+user.data.entity.id+"/auctions/history",{
                    headers:{
                        [global.tokenHeader]:user.data.token
                    }
                }).then(result=>result.json())
                    .then(data=>{
                        if(data!==undefined){
                            setData(data.data);
                        }
                    })
                    .catch(err=>{
                        console.log(err);
                        alert("Please relog again to see historic , thanks")
                        setConnected(false);
                    });
            }
        },[]);
        return(
            connected ?
            <>
                <Navbar/>
                <main>
                    <div className="favourite-place place-padding">
                        <div className="container">
                            <div className="row">
                                <div className="col-lg-12">
                                    <div className="section-tittle text-center">
                                        <span>Historic</span>
                                        <h2>List of Auction</h2>
                                    </div>
                                </div>
                            </div>
                            <div className="row">
                                {data.map(auction=><AuctionListItem auction={auction} />)}
                            </div>
                        </div>
                    </div>
                </main>
                <Footer/>
            </>
        : <Navigate to={"/login"} />
        )
}