import {Component} from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import {Timer} from "../../components/Timer";

export default class AuctionProfil extends Component{
    render(){
        return(
            <>
                <Navbar/>
                <main>
                    <div className="favourite-place place-padding">
                        <div className="container">
                            <div className="row">
                            </div>
                            <div className="row">
                                <div className="col-xl-3 col-lg-3 col-md-4"></div>
                                <div className="col-xl-6 col-lg-6 col-md-8">
                                    <div className="single-place mb-30">
                                        <div className="place-img">
                                            <img src="assets/img/service/services2.jpg" alt=""/>
                                        </div>
                                        <div className="place-cap">
                                            <div className="place-cap-top">
                                                <span><i className="fas fa-clock"></i><span><Timer expirationDate={new Date(new Date().getTime() + 500000)} /></span> </span>
                                                <h3><a href="#">Auction Title</a></h3>
                                                <p className="dolor">Category <span>/ Product</span></p>
                                                <p>Auction Description</p>
                                                <a href="/auctions/profil/bid">Bid</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-xl-3 col-lg-3 col-md-4"></div>
                            </div>
                        </div>
                    </div>
                </main>
                <Footer/>
            </>
        )
    }
}