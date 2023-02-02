import { Component } from "react";
export default class Register extends Component{
    render(){
        return(
            <div className="authincation h-100" style={{marginTop:150}}>
                <div className="container-fluid h-100">
                    <div className="row justify-content-center h-100 align-items-center">
                        <div className="col-md-6">
                            <div className="authincation-content">
                                <div className="row no-gutters">
                                    <div className="col-xl-12">
                                        <div className="auth-form">
                                            <h4 className="text-center mb-4">Sign up your account</h4>
                                            <form action="index.html">
                                                <div className="form-group">
                                                    <label><strong>Username</strong></label>
                                                    <input type="text" className="form-control" placeholder="username"/>
                                                </div>
                                                <div className="form-group">
                                                    <label><strong>Email</strong></label>
                                                    <input type="email" className="form-control" placeholder="hello@example.com"/>
                                                </div>
                                                <div className="form-group">
                                                    <label><strong>Password</strong></label>
                                                    <input type="password" className="form-control" value="Password"/>
                                                </div>
                                                <div className="text-center mt-4">
                                                    <button type="submit" className="btn btn-primary btn-block">Sign me up</button>
                                                </div>
                                            </form>
                                            <div className="new-account mt-3">
                                                <p>Already have an account? <a className="text-primary" href="/">Sign in</a></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}