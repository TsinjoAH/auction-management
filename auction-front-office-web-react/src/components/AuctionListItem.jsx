import {Component} from "react";
import {Timer} from "./Timer";
import global from "../global.json";
import {useNavigate} from "react-router-dom";

export default function AuctionListItem(props){
    const navigate=useNavigate();
    const user=JSON.parse(localStorage.getItem("user"));
    const clicked=(auction)=>{
        navigate("/profile",{state:auction})
    };
        return (
            <>
                <div onClick={()=>clicked(props.auction)} className="col-xl-4 col-lg-4 col-md-6">
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
                                {localStorage.getItem("user")!==null?
                                    <p className="dolor">
                                        {
                                            props.auction.winner===user.data.entity.id?
                                                <p>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                         fill="currentColor" className="bi bi-trophy-fill"
                                                         viewBox="0 0 16 16">
                                                        <path
                                                            d="M2.5.5A.5.5 0 0 1 3 0h10a.5.5 0 0 1 .5.5c0 .538-.012 1.05-.034 1.536a3 3 0 1 1-1.133 5.89c-.79 1.865-1.878 2.777-2.833 3.011v2.173l1.425.356c.194.048.377.135.537.255L13.3 15.1a.5.5 0 0 1-.3.9H3a.5.5 0 0 1-.3-.9l1.838-1.379c.16-.12.343-.207.537-.255L6.5 13.11v-2.173c-.955-.234-2.043-1.146-2.833-3.012a3 3 0 1 1-1.132-5.89A33.076 33.076 0 0 1 2.5.5zm.099 2.54a2 2 0 0 0 .72 3.935c-.333-1.05-.588-2.346-.72-3.935zm10.083 3.935a2 2 0 0 0 .72-3.935c-.133 1.59-.388 2.885-.72 3.935z"/>
                                                    </svg>
                                                </p>
                                                : <p>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                         fill="currentColor" className="bi bi-tag-fill" viewBox="0 0 16 16">
                                                        <path
                                                            d="M2 1a1 1 0 0 0-1 1v4.586a1 1 0 0 0 .293.707l7 7a1 1 0 0 0 1.414 0l4.586-4.586a1 1 0 0 0 0-1.414l-7-7A1 1 0 0 0 6.586 1H2zm4 3.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
                                                    </svg>
                                                </p>
                                        }
                                    </p>
                                    : ""
                                }
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
