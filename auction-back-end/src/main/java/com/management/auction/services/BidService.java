package com.management.auction.services;

import com.management.auction.models.Bid;
import com.management.auction.models.auction.Auction;
import com.management.auction.repos.BidRepo;
import custom.springutils.service.CrudServiceWithFK;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BidService extends CrudServiceWithFK<Bid, Auction, BidRepo> {
    public BidService(BidRepo repo) {
        super(repo);
    }

    @Override
    public List<Bid> findForFK(Auction auction) {
        return this.repo.findByAuctionId(auction.getId());
    }

}
