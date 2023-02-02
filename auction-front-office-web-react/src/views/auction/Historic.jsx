import {Component} from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import AuctionListItem from "../../components/AuctionListItem";
import AdvancedSearch from "../../components/AdvancedSearch";

export default class Historic extends Component{
    render(){
        return(
            <>
                <Navbar/>
                <main>
                    <AdvancedSearch/>
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
                                <AuctionListItem/>
                                <AuctionListItem/>
                                <AuctionListItem/>
                                <AuctionListItem/>
                                <AuctionListItem/>
                                <AuctionListItem/>
                                <AuctionListItem/>
                            </div>
                        </div>
                    </div>
                    <div className="pagination-area pb-100 text-center">
                        <div className="container">
                            <div className="row">
                                <div className="col-xl-12">
                                    <div className="single-wrap d-flex justify-content-center">
                                        <nav aria-label="Page navigation example">
                                            <ul className="pagination justify-content-start">
                                                <li className="page-item"><a className="page-link" href="#"><span
                                                    className="flaticon-arrow roted left-arrow"></span></a></li>
                                                <li className="page-item active"><a className="page-link"
                                                                                    href="#">01</a></li>
                                                <li className="page-item"><a className="page-link" href="#">02</a></li>
                                                <li className="page-item"><a className="page-link" href="#">03</a></li>
                                                <li className="page-item"><a className="page-link" href="#"><span
                                                    className="flaticon-arrow right-arrow"></span></a></li>
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
        )
    }
}