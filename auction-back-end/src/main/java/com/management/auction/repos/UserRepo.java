package com.management.auction.repos;

import com.management.auction.models.User;
import custom.springutils.LoginRepo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User,Long>, LoginRepo<User> {
}
