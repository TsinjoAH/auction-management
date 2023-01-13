package com.management.auction.repos.token;

import com.management.auction.models.token.AdminToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminTokenRepo extends JpaRepository<AdminToken,String> {
}
