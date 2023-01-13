package com.management.auction.repos;

import com.management.auction.models.Commission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CommissionRepo extends JpaRepository<Commission,Long> {
    @Query(value = "SELECT * FROM commission ORDER BY set_date DESC LIMIT 1",nativeQuery = true)
    public Commission getLatest();
}
