package com.management.auction.repository;

import custom.springutils.LoginRepo;
import com.management.auction.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User, Long>, LoginRepo<User> {
}
