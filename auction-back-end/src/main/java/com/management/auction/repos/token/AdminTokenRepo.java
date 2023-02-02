package com.management.auction.repos.token;

import com.management.auction.models.token.AdminToken;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface AdminTokenRepo extends MongoRepository<AdminToken,String> {
    AdminToken getByToken(String token);
}
