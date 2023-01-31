import { Component } from "react";
export default class Navbar extends Component{
    render(){
        return(
            <header>
                <div className="header-area">
                    <div className="main-header ">
                        <div className="header-bottom  header-sticky">
                            <div className="container">
                                <div className="row align-items-center">
                                    <div className="col-xl-2 col-lg-2 col-md-1">
                                        <div className="logo">
                                            <a href=""><h3>Auction</h3></a>
                                        </div>
                                    </div>
                                    <div className="col-xl-10 col-lg-10 col-md-10">
                                        <div className="main-menu f-right d-none d-lg-block">
                                            <nav>
                                                <ul id="navigation">
                                                    <li><a href="">Home</a></li>
                                                    <li><a href="">Auction</a>
                                                        <ul className="submenu">
                                                            <li><a href="">List</a></li>
                                                            <li><a href="">Historic</a></li>
                                                        </ul>
                                                    </li>
                                                    <li><a href="">Contact Us</a></li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                    <div className="col-12">
                                        <div className="mobile_menu d-block d-lg-none"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
    );
    }
}