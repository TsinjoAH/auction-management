package com.management.auction.repos.auction;

import com.management.auction.models.auction.AuctionView;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AuctionViewRepo extends JpaRepository<AuctionView, Long> {
    List<AuctionView> findByUserId(Long id);
}
