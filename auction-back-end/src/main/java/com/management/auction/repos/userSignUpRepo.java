package com.management.auction.repos;

import com.management.auction.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface userSignUpRepo extends JpaRepository<User,Long> {
}
