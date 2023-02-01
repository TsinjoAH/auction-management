import {Component} from "react";

export default class AdvancedSearch extends Component {
    render() {
        return (
            <>
                <div className="slider-area ">
                    <div className="single-slider slider-height2 d-flex align-items-center" style={{background:"#f0f0f0"}}>
                        <div className="container">
                            <div className="row">
                                <div className="col-xl-12">
                                    <div className="hero-cap text-center">
                                        <h3>Advanced Search</h3>
                                    </div>

                                    <div>
                                        <input type="text" className="form-control" placeholder="Keyword"/>
                                    </div>
                                    <br/>
                                    <div className="row">
                                        <div className="col-lg-3">
                                            <input type="date" className="form-control"/>
                                        </div>
                                        <div className="col-lg-3">
                                            <select className="form-control" name="">
                                                <option>Category</option>
                                                <option value="">Category 1</option>
                                                <option value="">Category 2</option>
                                                <option value="">Category 3</option>
                                            </select>
                                        </div>
                                        <div className="col-lg-3">
                                            <input type="text" className="form-control" placeholder="Price"/>
                                        </div>
                                        <div className="col-lg-3">
                                            <select className="form-control" name="">
                                                <option>Status</option>
                                                <option value="">In Progress</option>
                                                <option value="">Not Yet Started</option>
                                                <option value="">Finished</option>
                                            </select>
                                        </div>
                                    </div>
                                    <br/>

                                    <div className="row">
                                        <div className="col-lg-5">
                                        </div>
                                        <div className="col-lg-2">
                                            <input type="submit" className="btn btn-primary" value="Search"/>
                                        </div>
                                        <div className="col-lg-5">
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
