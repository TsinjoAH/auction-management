package com.management.auction.services.user;

import com.management.auction.models.User;
import com.management.auction.repos.UserRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService extends CrudService<User, UserRepo> {
    public UserService(UserRepo repo) {
        super(repo);
    }

    @Override
    public User create(User obj) throws CustomException {
        List<User> users = this.repo.findByEmail(obj.getEmail());
        if (!users.isEmpty()) throw new CustomException("Email is already used");
        return super.create(obj);
    }
}
