package com.management.auction.controllers;

import com.management.auction.models.Bid;
import com.management.auction.models.auction.Auction;
import com.management.auction.services.AuctionService;
import com.management.auction.services.BidService;
import custom.springutils.exception.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static custom.springutils.util.ControllerUtil.returnSuccess;

@RestController
@RequestMapping("/auctions/{fkId}/bids")
public class BidController {

    @Autowired
    AuctionService auctionService;

    @Autowired
    BidService service;

    @PostMapping("")
    public ResponseEntity<?> bid (@PathVariable Long fkId, @RequestBody Bid bid) throws CustomException {
        Auction auction = this.auctionService.findById(fkId);
        bid.setFK(auction);
        return returnSuccess(this.service.create(bid), HttpStatus.CREATED);
    }

}
