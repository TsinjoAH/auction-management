package com.management.auction.services;

import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.models.auction.AuctionPic;
import com.management.auction.repos.auction.AuctionPicRepo;
import com.management.auction.models.auction.AuctionReceiver;
import com.management.auction.repos.auction.AuctionRepo;
import com.management.auction.repos.BidRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudServiceWithFK;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Service
public class AuctionService extends CrudServiceWithFK<Auction, User, AuctionRepo> {
    private final AuctionPicRepo auctionPicRepository;
    @Autowired
    private BidRepo bidRepo;
    public AuctionService(AuctionRepo repo,
                          AuctionPicRepo auctionPicRepository) {
        super(repo);
        this.auctionPicRepository = auctionPicRepository;
    }

    @Override
    public List<Auction> findForFK(User user) {
        return this.repo.findByUserId(user.getId());
    }

    @Override
    public Auction findById(Long id) {
        Auction auction = super.findById(id);
        if(auction == null){
            return null;
        }
        auction.setBids(bidRepo.findByAuctionId(id));
        return auction;
    }

    @Transactional
    public Auction create(AuctionReceiver auctionReceiver) throws CustomException, IOException {
        Auction auction = super.create(auctionReceiver.getAuction());
        List<AuctionPic> auctionPics = auctionReceiver.getAuctionPics();
        auctionPicRepository.saveAll(auctionPics);
        return auction;
    }
}
