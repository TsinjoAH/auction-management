package com.management.auction.service;

import custom.springutils.service.LoginService;
import com.management.auction.models.User;
import com.management.auction.repository.UserRepo;

public class UserLoginService extends LoginService<User, UserRepo> {

    public UserLoginService(UserRepo repo) {
        super(repo);
    }

    @Override
    public boolean isConnected(String s) {
        return false;
    }

    @Override
    public boolean logout(String s) {
        return false;
    }
}
