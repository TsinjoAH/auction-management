import {Component, useEffect, useState} from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import AuctionListItem from "../../components/AuctionListItem";
import AdvancedSearch from "../../components/AdvancedSearch";
import global from "../../global.json";

export default function AuctionList(props){
    const [data,setData]=useState(null);
    const [page,setPage]=useState(0);
    useEffect(()=>{
        setData(null);
        fetch(global.link+"/auctions/"+page).then(result=>result.json())
            .then(data=>{
                setData(data.data);
            })
            .catch(err=>{
                console.log(err);
            });
        },[page])
        return(
            data !=null ?

            <>
                <Navbar/>
                <main>
                    <br/><br/>
                    <br/>

                    <AdvancedSearch setData={setData}/>
                    <div className="favourite-place place-padding">
                        <div className="container">
                            <div className="row">
                                <div className="col-lg-12">
                                    <div className="section-tittle text-center">
                                        <span>Auctions that you have bid on</span>
                                        <h2>List of Auction</h2>
                                    </div>
                                </div>
                            </div>
                            {data.length > 0 ?
                                <div className="row">
                                    {data.map(auction=> <AuctionListItem auction={auction} />)}
                                </div>
                                :
                                    <h1>No more auction</h1>
                            }
                        </div>
                    </div>
                    <div className="pagination-area pb-100 text-center">
                        <div className="container">
                            <div className="row">
                                <div className="col-xl-12">
                                    <div className="single-wrap d-flex justify-content-center">
                                        <nav aria-label="Page navigation example">
                                            <ul className="pagination justify-content-start">
                                                <li key={0} className="page-item"><p className="page-link" onClick={()=>setPage(page-1)}><span
                                                    className="flaticon-arrow roted left-arrow"></span></p></li>
                                                <li key={1} className="page-item active"><p className="page-link">{page}</p></li>
                                                <li key={2} className="page-item"><p className="page-link" onClick={()=>setPage(page+1)} >{page+1}</p></li>
                                                <li key={3} className="page-item"><p className="page-link" onClick={()=>setPage(page+2)} >{page+2}</p></li>
                                                <li key={4} className="page-item"><p className="page-link" onClick={()=>setPage(page+1)} ><span
                                                    className="flaticon-arrow right-arrow"></span></p></li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <Footer/>
                </>
                :
                <div id="preloader-active">
                    <div className="preloader d-flex align-items-center justify-content-center">
                        <div className="preloader-inner position-relative">
                            <div className="preloader-circle"></div>
                            <div className="preloader-img pere-text">
                                <img src="./assets/img/logo/laptop.png" alt=""/>
                            </div>
                        </div>
                    </div>
                </div>
        )
    }