package com.management.auction.services.user;

import com.management.auction.models.User;
import com.management.auction.repos.userSignUpRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class UserSignUpService extends CrudService<User, userSignUpRepo> {

    public UserSignUpService(userSignUpRepo repo) {
        super(repo);
    }
}
