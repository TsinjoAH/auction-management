package com.management.auction.services;

import com.management.auction.models.Bid;
import com.management.auction.models.auction.Auction;
import com.management.auction.repos.BidRepo;
import com.management.auction.repos.UserRepo;
import com.management.auction.repos.auction.AuctionRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudServiceWithFK;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BidService extends CrudServiceWithFK<Bid, Auction, BidRepo> {

    @Autowired
    UserRepo userRepo;
    @Autowired
    AuctionRepo auctionRepo;

    public BidService(BidRepo repo) {
        super(repo);
    }

    @Override
    public List<Bid> findForFK(Auction auction) {
        return this.repo.findByAuctionIdOrderByIdDesc(auction.getId());
    }

    @Override
    @Transactional(rollbackFor = {CustomException.class})
    public Bid create(Bid obj) throws CustomException {
        double maxBid =0;
        Auction auction=auctionRepo.findById(obj.getAuctionId()).get();
        try {
            this.repo.getMaxBid(obj.getAuctionId());
        }catch (Exception e){
            maxBid=0;
        }
        if (maxBid >= obj.getAmount()) {
            throw new CustomException("bid invalid");
        }
        if(obj.getAmount()<auction.getStartPrice()){
            throw new CustomException("bid invalid");
        }
        if (userRepo.getAccountBalance(obj.getUser().getId()) < obj.getAmount()) {
            throw new CustomException("your account does not have enough balance");
        }
        return super.create(obj);
    }

}
