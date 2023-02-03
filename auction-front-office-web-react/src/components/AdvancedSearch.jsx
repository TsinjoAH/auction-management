import {Component, useEffect, useState} from "react";
import global from "../global.json";
export default function AdvancedSearch(props){
    const [categ,setCateg]=useState([]);
    useEffect(()=>{
        fetch(global.link+"/categories")
            .then(result=>result.json())
            .then(data=>setCateg(data.data));
    },[]);
    const val=(event)=>{
        let keyword=document.getElementById("keyword");
        let mins=document.getElementById("mins");
        let mine=document.getElementById("mine");
        let maxs=document.getElementById("maxs");
        let maxe=document.getElementById("maxe");
        let price=document.getElementById("price");
        let status=document.getElementById("status");
        let categ=document.getElementById("categ");
        let url=global.link+"/auctions/filter?1=1";
        if(keyword.value.length>0){
            url+="&keyword="+encodeURIComponent(keyword.value);
        }
        if(mins.value.length>0){
            url+="&startMinDate="+encodeURIComponent(mins.value.replace("T"," ")+":00");
        }
        if(maxs.value.length>0){
            url+="&startMaxDate="+encodeURIComponent(maxs.value.replace("T"," ")+":00");
        }
        if(mine.value.length>0){
            url+="&endMinDate="+encodeURIComponent(mins.value.replace("T"," ")+":00");
        }
        if(maxe.value.length>0){
            url+="&endMaxDate="+encodeURIComponent(maxe.value.replace("T"," ")+":00");
        }
        if(price.value.length>0){
            url+="&price="+price.value;
        }
        if(status.value.length>0){
            url+="&status="+status.value;
        }
        if(categ.value.length>0){
            url+="&category="+categ.value;
        }
        fetch(url)
            .then(result=>result.json())
            .then(data=>props.setData(data.data))
    }
        return (
            <>
                <div className="slider-area ">
                    <div className="single-slider slider-height2 d-flex align-items-center" style={{background:"#f0f0f0"}}>
                        <div className="container">
                            <div className="row">
                                <div className="col-xl-12">
                                    <div className="hero-cap text-center">
                                        <h3>Advanced Search</h3>
                                    </div>

                                    <div>
                                        <input type="text" className="form-control" id={"keyword"} placeholder="Keyword"/>
                                    </div>
                                    <br/>
                                    <div className="row">
                                        <div className="col-lg-3">
                                            Min start date
                                            <input type={"datetime-local"} className="form-control" id={"mins"}/>
                                        </div>
                                        <div className="col-lg-3">
                                            Max start date
                                            <input type={"datetime-local"} className="form-control" id={"maxs"}/>
                                        </div>
                                        <div className="col-lg-3">
                                            Min end date
                                            <input type={"datetime-local"} className="form-control" id={"mine"}/>
                                        </div>
                                        <div className="col-lg-3">
                                            Max en date
                                            <input type={"datetime-local"} className="form-control" id={"maxe"}/>
                                        </div>
                                        <div className="col-lg-3">
                                            <select className="form-control" id="categ">
                                                <option value={""}>Category</option>
                                                {categ.map(cat=> <option value={cat.id}>{cat.name}</option>)}
                                            </select>
                                        </div>
                                        <div className="col-lg-3">
                                            <input type="text" className="form-control" id={"price"} placeholder="Price"/>
                                        </div>
                                        <div className="col-lg-3">
                                            <select className="form-control" id="status">
                                                <option value={""}>Status</option>
                                                <option value="1">In Progress</option>
                                                <option value="0">Not Started Yet </option>
                                                <option value="2">Finished</option>
                                            </select>
                                        </div>
                                    </div>
                                    <br/>
                                    <div className="row">
                                        <div className="col-lg-5">
                                        </div>
                                        <div className="col-lg-2">
                                            <button className="btn btn-primary" onClick={val}>Search</button>
                                        </div>
                                        <div className="col-lg-5">
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
