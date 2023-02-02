package com.management.auction.repos.token;

import com.management.auction.models.token.UserToken;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserTokenRepo extends MongoRepository<UserToken, String> {
    UserToken getByToken(String token);
}
