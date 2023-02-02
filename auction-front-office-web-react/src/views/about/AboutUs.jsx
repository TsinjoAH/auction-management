import { Component } from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
export default class AboutUs extends Component{
    render(){
        return(
            <>
                <Navbar/>
                <main>

                    <div className="slider-area ">
                        <div className="single-slider slider-height2 d-flex align-items-center"
                             data-background="assets/img/hero/about.jpg">
                            <div className="container">
                                <div className="row">
                                    <div className="col-xl-12">
                                        <div className="hero-cap text-center">
                                            <h2>About Us</h2>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="support-company-area servic-padding fix">
                        <div className="container">
                            <div className="row align-items-center">
                                <div className="col-xl-6 col-lg-6">
                                    <div className="support-location-img mb-50">
                                        <img src="assets/img/service/support-img.jpg" alt=""/>
                                            <div className="support-img-cap">
                                                <span>Since 1992</span>
                                            </div>
                                    </div>
                                </div>
                                <div className="col-xl-6 col-lg-6">
                                    <div className="right-caption">
                                        <div className="section-tittle section-tittle2">
                                            <span>About Our Company</span>
                                            <h2>We are Go Trip <br/>Ravels Support Company</h2>
                                        </div>
                                        <div className="support-caption">
                                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                                                tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
                                                veniam, quis nostrud</p>
                                            <div className="select-suport-items">
                                                <label className="single-items">Lorem ipsum dolor sit amet
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">Consectetur adipisicing sed do
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">Eiusmod tempor incididunt
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">Ad minim veniam, quis nostrud.
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                            </div>
                                            <a href="#" className="btn border-btn">Search</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="our-services place-padding">
                        <div className="container">
                            <div className="row d-flex justify-contnet-center">
                                <div className="col-xl-3 col-lg-3 col-md-3 col-sm-6">
                                    <div className="single-services text-center mb-30">
                                        <div className="services-ion">
                                            <span className="flaticon-tour"></span>
                                        </div>
                                        <div className="services-cap">
                                            <h5>8000+ Our Local<br/>Guides</h5>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-xl-3 col-lg-3 col-md-3 col-sm-6">
                                    <div className="single-services text-center mb-30">
                                        <div className="services-ion">
                                            <span className="flaticon-pay"></span>
                                        </div>
                                        <div className="services-cap">
                                            <h5>100% Trusted Tour<br/>Agency</h5>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-xl-3 col-lg-3 col-md-3 col-sm-6">
                                    <div className="single-services text-center mb-30">
                                        <div className="services-ion">
                                            <span className="flaticon-experience"></span>
                                        </div>
                                        <div className="services-cap">
                                            <h5>28+ Years of Travel<br/>Experience</h5>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-xl-3 col-lg-3 col-md-3 col-sm-6">
                                    <div className="single-services text-center mb-30">
                                        <div className="services-ion">
                                            <span className="flaticon-good"></span>
                                        </div>
                                        <div className="services-cap">
                                            <h5>98% Our Travelers<br/>are Happy</h5>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <Footer/>
            </>
        );
    }
}