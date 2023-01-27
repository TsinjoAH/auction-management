package com.management.auction.services.user;

import com.management.auction.models.User;
import com.management.auction.models.token.UserToken;
import com.management.auction.repos.UserRepo;
import com.management.auction.repos.token.UserTokenRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.sql.Timestamp;
import java.time.LocalDateTime;

@Service
public class UserLoginService extends LoginService<User, UserRepo> {

    @Autowired
    private UserTokenRepo tokenRepo;

    public UserLoginService(UserRepo repo) {
        super(repo);
    }

    @Override
    public boolean isConnected(String s) throws CustomException {
        UserToken token = tokenRepo.findById(s).orElse(null);
        if (token == null) return false;
        if (token.getValidity()) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            if (now.compareTo(token.getExpirationDate()) < 0) {
                logout(s);
                return false;
            }
            return true;
        }
        return false;
    }

    @Override
    public void saveToken(String s, User user) {
        UserToken token = new UserToken();
        token.setToken(s);
        token.setUserId(user.getId());
        token.setExpirationDate(Timestamp.valueOf(LocalDateTime.now().plusDays(7)));

        try {
            tokenRepo.save(token);
        }
        catch (Throwable e) {
            throw e;
        }
    }

    @Override
    public boolean logout(String s) throws CustomException {
        UserToken token = tokenRepo.findById(s).orElse(null);
        if (token == null) throw new CustomException("user not connected");
        token.setValidity(false);
        tokenRepo.save(token);
        return true;
    }

}
