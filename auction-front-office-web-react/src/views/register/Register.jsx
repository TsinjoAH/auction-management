
import global from "../../global.json";
import {useNavigate} from "react-router-dom";
export default function Register(props){
    const navigate=useNavigate();
    const signup=(event)=>{
        const user={
            "name":document.getElementById("username").value,
            "email":document.getElementById("email").value,
            "password":document.getElementById("password").value
        }
        fetch(global.link+"/users/signup",{
            method:"POST",
            body:JSON.stringify(user),
            headers:{
                "content-type":"application/json"
            }
        }).then(result=>{
            if(result.status===200){
                navigate("/login");
            }else{
                result.text().then(t=>{
                    let message=JSON.parse(t);
                    alert(message.message);
                })
                navigate("/register")
            }
        });
    }
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
                                                <div className="form-group">
                                                    <label><strong>Username</strong></label>
                                                    <input type="text" className="form-control" placeholder="username" id={"username"}/>
                                                </div>
                                                <div className="form-group">
                                                    <label><strong>Email</strong></label>
                                                    <input type="email" className="form-control" placeholder="hello@example.com" id={"email"}/>
                                                </div>
                                                <div className="form-group">
                                                    <label><strong>Password</strong></label>
                                                    <input type="password" className="form-control" id={"password"}/>
                                                </div>
                                                <div className="text-center mt-4">
                                                    <button  className="btn btn-primary btn-block" onClick={signup}>Sign me up</button>
                                                </div>
                                            <div className="new-account mt-3">
                                                <p>Already have an account? <a className="text-primary" href="/login">Sign in</a></p>
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