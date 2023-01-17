package com.management.auction.controllers;

import com.management.auction.models.Criteria;
import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.models.auction.AuctionReceiver;
import com.management.auction.services.AuctionService;
import com.management.auction.services.user.UserService;
import custom.springutils.controller.CrudWithFK;
import custom.springutils.exception.CustomException;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;


@RestController
@RequestMapping("/users/{fkId}/auctions")
public class AuctionController{
    @Autowired
    AuctionService service;
    @Autowired
    UserService userService;
    //No Update
    @GetMapping({"/{id}"})
    public ResponseEntity<SuccessResponse> findById(@PathVariable("id") Long id) {
        return ControllerUtil.returnSuccess(this.service.findById(id), HttpStatus.OK);
    }

    @GetMapping({""})
    public ResponseEntity<SuccessResponse> findAll(@PathVariable Long fkId) {
        User fk = this.userService.findById(fkId);
        return ControllerUtil.returnSuccess(this.service.findForFK(fk), HttpStatus.OK);
    }

    @PostMapping("")
    public ResponseEntity<SuccessResponse> createAuction(@PathVariable Long fkId, @RequestBody AuctionReceiver auctionReceiver) throws Exception{
        User fk = this.userService.findById(fkId);
        auctionReceiver.getAuction().setFK(fk);
        return ControllerUtil.returnSuccess(this.service.create(auctionReceiver), HttpStatus.CREATED);
    }
    @PostMapping("/filter")
    public ResponseEntity<SuccessResponse> filter(@RequestBody Criteria criteria, @PathVariable String fkId) throws CustomException{
        return ControllerUtil.returnSuccess(this.service.findByCriteria(criteria),HttpStatus.OK);
    }
}
