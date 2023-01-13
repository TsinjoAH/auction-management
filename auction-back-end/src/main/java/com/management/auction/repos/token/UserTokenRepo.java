package com.management.auction.repos.token;

import com.management.auction.models.token.UserToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserTokenRepo extends JpaRepository<UserToken, String> {
}
