package com.management.auction.controllers;

import com.management.auction.models.User;
import com.management.auction.services.user.UserLoginService;
import com.management.auction.services.user.UserService;
import custom.springutils.controller.LoginController;
import custom.springutils.exception.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static custom.springutils.util.ControllerUtil.returnSuccess;

@RestController
@RequestMapping("/users")
public class  UserController extends LoginController<User, UserLoginService> {

    @Autowired
    UserService userService;

    public UserController(UserLoginService service) {
        super(service);
    }

    @Override
    public String getRequestHeaderKey() {
        return "user_token";
    }

    @PostMapping
    public ResponseEntity<?> signup (@RequestBody User user) throws CustomException {
        return returnSuccess(this.userService.create(user), HttpStatus.OK);
    }
}
