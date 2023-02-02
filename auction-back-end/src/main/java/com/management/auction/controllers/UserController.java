package com.management.auction.controllers;

import com.management.auction.models.User;
import com.management.auction.services.user.UserLoginService;
import com.management.auction.services.user.UserService;
import custom.springutils.controller.LoginController;
import custom.springutils.exception.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static custom.springutils.util.ControllerUtil.returnSuccess;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UserController extends LoginController<User, UserLoginService> {
    @Autowired
    UserService userService;

    public UserController(UserLoginService service) {
        super(service);
    }

    @Override
    public String getRequestHeaderKey() {
        return "user_token";
    }

    @PostMapping("/signup")
    public ResponseEntity<?> signup (@RequestBody User user) throws CustomException {
        return returnSuccess(this.userService.create(user), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById (@PathVariable Long id) {
        return returnSuccess(this.userService.findById(id), HttpStatus.OK);
    }

}
