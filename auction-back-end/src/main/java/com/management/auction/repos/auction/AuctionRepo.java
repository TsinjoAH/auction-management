package com.management.auction.repos.auction;

import com.management.auction.models.auction.Auction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.ListPagingAndSortingRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface AuctionRepo extends JpaRepository<Auction, Long> ,AuctionCriteriaRepo, ListPagingAndSortingRepository<Auction,Long> {
    List<Auction> findByUserId(Long id);

    @Query(nativeQuery = true, value = "select auction_id from v_user_auction where user_id = ?1 ORDER BY auction_id DESC")
    List<Long> history(Long userId);
    Page<Auction> findByUserId(Long id,Pageable pageable);

    @Override
    Page<Auction> findAll(Pageable pageable);
}
