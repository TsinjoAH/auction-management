package com.management.auction.services;

import com.management.auction.models.User;
import com.management.auction.repos.UserRepo;
import com.management.auction.services.common.CrudService;
import org.springframework.stereotype.Service;

@Service
public class UserService extends CrudService<User, UserRepo> {
    public UserService(UserRepo repo) {
        super(repo);
    }
}
