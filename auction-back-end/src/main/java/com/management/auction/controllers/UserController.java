package com.management.auction.controllers;

import com.management.auction.models.User;
import com.management.auction.services.user.UserLoginService;
import custom.springutils.controller.LoginController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
public class UserController extends LoginController<User, UserLoginService> {

    public UserController(UserLoginService service) {
        super(service);
    }

    @Override
    public String getRequestHeaderKey() {
        return "user_token";
    }
}
