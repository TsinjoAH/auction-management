package com.management.auction.repos;

import com.management.auction.models.User;
import custom.springutils.LoginRepo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserRepo extends JpaRepository<User,Long>, LoginRepo<User> {

    @Query(nativeQuery = true, value = "select amount from balance where user_id = ?1")
    double getAccountBalance (Long userId);
}
