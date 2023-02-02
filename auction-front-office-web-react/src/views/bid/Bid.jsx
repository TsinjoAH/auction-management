import { Component } from "react";
import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import BidForm from "../../components/BidForm";
export default class Bid extends Component{
    render(){
        return(
            <>
                <Navbar/>
                    <BidForm/>
                <Footer/>
            </>
        );
    }
}