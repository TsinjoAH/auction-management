package com.management.auction.repos;

import com.management.auction.models.auction.Auction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AuctionRepo extends JpaRepository<Auction, Long> {
    List<Auction> findByUserId(Long id);

}
