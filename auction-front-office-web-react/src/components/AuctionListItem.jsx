import {Component} from "react";
import {Timer} from "./Timer";

export default class AuctionListItem extends Component {
    render() {
        return (
            <>
                <div className="col-xl-4 col-lg-4 col-md-6">
                    <div className="single-place mb-30">
                        <div className="place-img">
                            <img src="assets/img/service/services2.jpg" alt=""/>
                        </div>
                        <div className="place-cap">
                            <div className="place-cap-top">
                                <span><i className="fas fa-clock"></i><span><Timer expirationDate={new Date(new Date().getTime() + 500000)} /></span> </span>
                                <h3><a href="#">Auction Title</a></h3>
                                <p className="dolor">Category <span>/ Product</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </>
        );
    }
}
