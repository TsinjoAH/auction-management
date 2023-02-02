import {Component} from "react";

export default class BidForm extends Component {
    render() {
        return (
            <>
                <div className="authincation h-100" style={{marginTop: 50}}>
                    <div className="container-fluid h-100">
                        <div className="row justify-content-center h-100 align-items-center">
                            <div className="col-md-6">
                                <div className="authincation-content">
                                    <div className="row no-gutters">
                                        <div className="col-xl-12">
                                            <div className="auth-form">
                                                <h4 className="text-center mb-4">Bid on</h4>
                                                <form action="">
                                                    <div className="form-group">
                                                        <label><strong>Amount</strong></label>
                                                        <input type="text" className="form-control"
                                                               />
                                                    </div>
                                                    <div className="text-center">
                                                        <button type="submit" className="btn btn-primary btn-block">
                                                            Save
                                                        </button>
                                                        <br/>
                                                        <p className="text-danger">Error</p>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </>
        );
    }
}
