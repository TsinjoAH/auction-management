package com.management.auction.repos;

import com.management.auction.models.Bid;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface BidRepo extends JpaRepository<Bid, Long> {
    List<Bid> findByAuctionId(Long auctionId);

    @Query(nativeQuery = true, value = "select amount from bid where auction_id = ?1 order by amount desc limit 1")
    double getMaxBid(Long auctionId);
}
