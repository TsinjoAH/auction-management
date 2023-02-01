import { Component } from "react";
export default class Footer extends Component{
    render(){
        return(
            <>
                <footer>
                    <div className="footer-area footer-padding footer-bg">
                        <div className="container">
                            <div className="row pt-padding">
                                <div className="col-xl-7 col-lg-7 col-md-7">
                                    <div className="footer-copy-right">
                                        <p>
                                            Copyright &copy;
                                            2023
                                            All rights reserved | Group 14
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>
            </>
        );
    }
}