import { Component } from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
export default class Home extends Component{
    render(){
        return(
            <>
        <Navbar/>
        <div className="slider-area ">
            <div className="slider-active">
                <div className="single-slider slider-height d-flex align-items-center" style={{ backgroundImage:"url('assets/img/hero/Picsart_23-02-01_20-50-06-306.jpg')" }}>
                    <div className="container">
                        <div className="row">
                            <div className="col-xl-9 col-lg-9 col-md-9">
                                <div className="hero__caption">
                                    <h1>Auction <span>Website</span></h1>
                                    <p>Three, Two, One, Considered Sold</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <Footer/>
        </>
        );
    }
}