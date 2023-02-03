import {Component} from "react";
import {Timer} from "./Timer";
import global from "../global.json";
import {useNavigate} from "react-router-dom";

export default function AuctionListItem(props){
    const navigate=useNavigate();
    const clicked=(auction)=>{
        navigate("/profile",{state:auction})
    };
        return (
            <>
                <div className="col-xl-4 col-lg-4 col-md-6">
                    <div className="single-place mb-30">
                        {
                            props.auction.images.length>0?
                                <div className="place-img">
                                    <img src={global.link+"/"+props.auction.images[0].picPath}/>
                                </div>:""
                        }
                        <div className="place-cap">
                            <div className="place-cap-top">
                                <span><i className="fas fa-clock"></i><span><Timer expirationDate={Date.parse(props.auction.endDate)} beginDate={Date.parse(props.auction.beginDate)} /></span> </span>
                                <h3 onClick={()=>clicked(props.auction)} style={{cursor:"pointer"}}>{props.auction.title}</h3>
                                <p className="dolor">{props.auction.product.category.name} <span>/ {props.auction.product.name}</span></p>
                                <p className="dolor">{props.auction.max} Ar</p>
                                <p className="d-inline-block" style={{color:"#ffa800",cursor:"pointer"}} onClick={()=>clicked(props.auction)}>See more</p>
                            </div>
                        </div>
                    </div>
                </div>
            </>
        );
}
