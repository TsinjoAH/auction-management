import { Component } from "react";
export default class Navbar extends Component{
    render(){
        return(
            <header>
                <nav className="navbar navbar-light navbar-expand-md fixed-top py-3" style={{fontFamily: "Barlow Condensed",fontSize: 18,background: "#fff",boxShadow: "1px 1px 16px #61616196"}}>
                    <div className="container"><a className="navbar-brand d-flex align-items-center" href="#"><span
                        style={{fontWeight: "bold",fontSize:22}}>Auction</span></a>
                        <button data-bs-toggle="collapse" className="navbar-toggler" data-bs-target="#navcol-3"><span
                            className="visually-hidden"></span><span
                            className="navbar-toggler-icon"></span></button>
                        <div className="collapse navbar-collapse" id="navcol-3">
                            <ul className="navbar-nav mx-auto">
                                <li className="nav-item"><a className="nav-link active" href="/">Home</a></li>
                                <li className="nav-item"></li>
                                <li className="nav-item"></li>
                                <li className="nav-item dropdown"><a className="dropdown-toggle nav-link"
                                                                     aria-expanded="false" data-bs-toggle="dropdown"
                                                                     href="/">Auction</a>
                                    <div className="dropdown-menu"><a className="dropdown-item" href="/auctions">List</a><a
                                        className="dropdown-item" href="/history">Historic</a></div>
                                </li>
                                <li className="nav-item"><a className="nav-link active" href="/about">About us</a></li>
                            </ul>
                            <button className="btn-perso" href="" type="button" style={{background:"none",borderWidth:1,borderStyle:"solid",borderColor:"blue",width:100,height:40, color:"blue",borderRadius:5}}>Logout</button>
                        </div>
                    </div>
                </nav>
            </header>
    );
    }
}