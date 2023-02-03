import { Component } from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
export default class AboutUs extends Component{
    render(){
        return(
            <>
                <Navbar/>
                <main>
                    <div className="support-company-area servic-padding fix">
                        <div className="container">
                            <div className="row align-items-center">
                                <div className="col-xl-6 col-lg-6">
                                    <div className="support-location-img mb-50">
                                        <img src="assets/img/hero/IMG-20230203-WA0000.jpg" alt=""/>
                                            <div className="support-img-cap">
                                                <span>Since 2022</span>
                                            </div>
                                    </div>
                                </div>
                                <div className="col-xl-6 col-lg-6">
                                    <div className="right-caption">
                                        <div className="section-tittle section-tittle2">
                                            <span>About Our Team</span>
                                            <h2>We are Group 23 <br/>Web Crew</h2>
                                        </div>
                                        <div className="support-caption">
                                            <p></p>
                                            <div className="select-suport-items">
                                                <label className="single-items">ETU1466 - RAMANAMPAMONJY Riantsoa Lahatra
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">ETU1539 - ANDRIANARIVONY Tsinjo Herisetra
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">ETU1653 - RATOVONJANAHARY Harivelo Larousso
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                                <label className="single-items">ETU1667 - ROBEL Rova Fabrice
                                                    <input type="checkbox" checked="checked active"/>
                                                        <span className="checkmark"></span>
                                                </label>
                                            </div>
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