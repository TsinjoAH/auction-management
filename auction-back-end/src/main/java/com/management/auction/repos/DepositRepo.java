package com.management.auction.repos;

import com.management.auction.models.Deposit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DepositRepo extends JpaRepository<Deposit,Long> {
    List<Deposit> findByUserId(Long id);

    List<Deposit> findByApprovedIsFalse();
}
