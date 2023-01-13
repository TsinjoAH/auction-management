package com.management.auction.repos.auction;

import com.management.auction.models.auction.AuctionPic;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuctionPicRepo extends JpaRepository<AuctionPic, Long> {
}