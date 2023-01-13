package com.management.auction.repos;

import com.management.auction.models.Bid;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BidRepo extends JpaRepository<Bid, Long> {
    List<Bid> findByAuctionId(Long auctionId);
}
