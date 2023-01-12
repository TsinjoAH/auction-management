package com.management.auction.Controlleur;

import custom.springutils.controller.LoginController;
import com.management.auction.models.User;
import com.management.auction.service.UserLoginService;

public class Contr extends LoginController<User, UserLoginService> {
    public Contr(UserLoginService service) {
        super(service);
    }

    @Override
    public String getRequestHeaderKey() {
        return null;
    }
}
