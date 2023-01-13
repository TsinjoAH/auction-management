package com.management.auction.services;

import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.repos.AuctionRepo;
import custom.springutils.service.CrudServiceWithFK;
import custom.springutils.service.ServiceWithFK;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuctionService extends CrudServiceWithFK<Auction, User, AuctionRepo> implements ServiceWithFK<Auction, User> {

    public AuctionService(AuctionRepo repo) {
        super(repo);
    }

    @Override
    public List<Auction> findForFK(User user) {
        return this.repo.findByUserId(user.getId());
    }
}
