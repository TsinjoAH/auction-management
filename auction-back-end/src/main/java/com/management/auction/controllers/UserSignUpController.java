package com.management.auction.controllers;

import com.management.auction.models.User;
import com.management.auction.services.user.UserService;
import com.management.auction.services.user.UserSignUpService;
import custom.springutils.controller.CrudController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserSignUpController extends CrudController<User, UserSignUpService> {

    public UserSignUpController(UserSignUpService service) {
        super(service);
    }
}
