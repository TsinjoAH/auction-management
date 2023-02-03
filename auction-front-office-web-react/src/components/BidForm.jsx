import {Component, useState} from "react";
import global from "../global.json";

export default function BidForm(props){
    const [error,setError]=useState("");
    const add=(event)=>{
        let amount=document.getElementById("amount").value;
        let result={
            "user": {
                "id": props.user.entity.id
            },
            "amount": amount
        };
        fetch(global.link+"/auctions/"+props.auction.id+"/bids",{
            method:"POST",
            body:JSON.stringify(result),
            headers:{
                [global.tokenHeader]:props.user.token,
                "Content-Type":"application/json"
            }
        }).then(result=>{
            if(result.ok){
                alert("Auction validate");
            }else{
                result.text().then(t=>{
                    setError(JSON.parse(t).message);
                })
            }
        });
    }
    return (
        <>
            <div className="authincation h-100" style={{marginTop: 50}}>
                <div className="container-fluid h-100">
                    <div className="row justify-content-center h-100 align-items-center">
                        <div className="col-md-6">
                            <div className="authincation-content">
                                <div className="row no-gutters">
                                    <div className="col-xl-12">
                                        <div className="auth-form">
                                            <h4 className="text-center mb-4">Bid on</h4>
                                                <div className="form-group">
                                                    <label><strong>Amount</strong></label>
                                                    <input type="text" id={"amount"} className="form-control"/>
                                                </div>
                                                <div className="text-center">
                                                    <button className="btn btn-primary btn-block" onClick={add}>
                                                        Save
                                                    </button>
                                                    <br/>
                                                    <p className="text-danger">{error}</p>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
