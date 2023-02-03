import { Component } from "react";
import global from "../../global.json";
import {Navigate, useNavigate} from "react-router-dom";
export default function Login(props) {
    const navigate=useNavigate();
    const log = (event) => {
        let email = document.getElementById("email");
        let password = document.getElementById("password");
        let login = {
            "email": email.value,
            "password": password.value
        };
        fetch(global.link + "/users/login", {
            method: "POST",
            body: JSON.stringify(login),
            headers: {
                "Content-Type": "application/json"
            }
        }).then(result => result.json())
            .then(data => {
                if (data.code === 400) {
                    alert(data.message);
                } else {
                    localStorage.setItem("user", JSON.stringify(data));
                    navigate("/");
                }
            });
    };
    return (
        <div className="authincation h-100" style={{marginTop: 150}}>
            <div className="container-fluid h-100">
                <div className="row justify-content-center h-100 align-items-center">
                    <div className="col-md-6">
                        <div className="authincation-content">
                            <div className="row no-gutters">
                                <div className="col-xl-12">
                                    <div className="auth-form">
                                        <h4 className="text-center mb-4">Sign in your account</h4>
                                        <div className="form-group">
                                            <label><strong>Email</strong></label>
                                            <input type="email" className="form-control" name="email" id={"email"}
                                                   defaultValue="Steven@exemple.com"/>
                                        </div>
                                        <div className="form-group">
                                            <label><strong>Password</strong></label>
                                            <input type="password" className="form-control" name="password"
                                                   id={"password"} defaultValue="gemmedecristal"/>
                                        </div>
                                        <div className="form-row d-flex justify-content-between mt-4 mb-2">
                                        </div>
                                        <div className="text-center">
                                            <button type="submit" className="btn btn-primary btn-block"
                                                    onClick={log}>Sign me in
                                            </button>
                                        </div>
                                        <div className="new-account mt-3">
                                            <p>Don't have an account? <a className="text-primary" href="/register">Sign
                                                up</a></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}