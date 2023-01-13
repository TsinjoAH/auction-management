package com.management.auction.repos;

import com.management.auction.models.Admin;
import custom.springutils.LoginRepo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepo extends JpaRepository<Admin, Long>, LoginRepo<Admin> {
}
