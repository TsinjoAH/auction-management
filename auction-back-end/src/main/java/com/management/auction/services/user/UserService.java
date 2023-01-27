package com.management.auction.services.user;

import com.management.auction.models.User;
import com.management.auction.repos.UserRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class UserService extends CrudService<User, UserRepo> {
    public UserService(UserRepo repo) {
        super(repo);
    }

    @Override
    public User create(User obj) throws CustomException {
        User user = this.repo.findByEmail(obj.getEmail()).get(0);
        if (user != null) throw new CustomException("Email is already used");
        return super.create(obj);
    }
}
