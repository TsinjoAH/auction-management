package com.management.auction.controllers;

import com.management.auction.models.Bid;
import com.management.auction.models.auction.Auction;
import com.management.auction.models.auction.AuctionView;
import com.management.auction.services.AuctionService;
import com.management.auction.services.BidService;
import com.management.auction.services.user.UserService;
import custom.springutils.exception.CustomException;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/users/{fkId}/auctions/{fkId2}/bids")
public class BidController {
    @Autowired
    AuctionService service;
    @Autowired
    UserService userService;
    @Autowired
    BidService bidService;

    @GetMapping({""})
    public ResponseEntity<SuccessResponse> findAllBid(@PathVariable("fkId2") Long fkId2) {
        Auction auction = this.service.findById(fkId2);
        return ControllerUtil.returnSuccess(this.bidService.findForFK(auction), HttpStatus.OK);
    }

    @PostMapping("")
    public ResponseEntity<SuccessResponse> create(@PathVariable Long fkId2, @RequestBody Bid bid) throws CustomException {
        Auction auction = this.service.findById(fkId2);
        AuctionView auctionView = this.service.findByIdView(fkId2);
        if (auctionView.getStatus() == 3) {
            throw new CustomException("The auction hasn't started yet");
        }
        if (auctionView.getStatus() == 2) {
            throw new CustomException("The auction is already finished");
        } else {
            bid.setFK(auction);
            return ControllerUtil.returnSuccess(this.bidService.create(bid), HttpStatus.CREATED);
        }
    }
}
