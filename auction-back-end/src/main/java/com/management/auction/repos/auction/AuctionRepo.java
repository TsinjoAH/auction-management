package com.management.auction.repos.auction;

import com.management.auction.models.auction.Auction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AuctionRepo extends JpaRepository<Auction, Long> ,AuctionCriteriaRepo{
    List<Auction> findByUserId(Long id);

    @Query(nativeQuery = true, value = "select auction_id from v_user_auction where user_id = ?1")
    List<Long> history(Long userId);
}
