package com.management.auction.controllers;

import com.management.auction.models.Bid;
import com.management.auction.models.Criteria;
import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.models.auction.Auction;
import com.management.auction.models.auction.AuctionReceiver;
import com.management.auction.services.AuctionService;
import com.management.auction.services.BidService;
import com.management.auction.services.user.UserService;
import custom.springutils.exception.CustomException;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static custom.springutils.util.ControllerUtil.returnSuccess;
import java.sql.Timestamp;


@RestController
@RequestMapping("/users/{fkId}/auctions")
public class AuctionController {

    @Autowired
    AuctionService service;
    @Autowired
    UserService userService;

    @Autowired
    BidService bidService;


    //No Update
    @GetMapping({"/{id}"})
    public ResponseEntity<SuccessResponse> findById(@PathVariable("id") Long id) {
        return returnSuccess(this.service.findByIdView(id), HttpStatus.OK);
    }

    @GetMapping({""})
    public ResponseEntity<SuccessResponse> findAll(@PathVariable Long fkId) {
        User fk = this.userService.findById(fkId);
        return returnSuccess(this.service.findForFKView(fk), HttpStatus.OK);
    }


    @PostMapping("")
    public ResponseEntity<SuccessResponse> createAuction(@PathVariable Long fkId, @RequestBody AuctionReceiver auctionReceiver) throws Exception{
        User fk = this.userService.findById(fkId);
        auctionReceiver.getAuction().setFK(fk);
        return returnSuccess(this.service.create(auctionReceiver), HttpStatus.CREATED);
    }

    @PostMapping("/filter")
    public ResponseEntity<SuccessResponse> filter(@RequestBody Criteria criteria) throws CustomException{
        return returnSuccess(this.service.findByCriteria(criteria),HttpStatus.OK);
    }

    @GetMapping("/history")
    public ResponseEntity<?> history (@PathVariable Long fkId) throws CustomException {
        User user = this.userService.findById(fkId);
        return returnSuccess(this.service.history(user), HttpStatus.OK);
    }

    @GetMapping("/filter")
    public ResponseEntity<SuccessResponse> filter(@RequestParam(required = false)String keyword, @RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-mm-dd HH:mm:ss")Timestamp startMinDate, @RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-mm-dd HH:mm:ss")Timestamp startMaxDate, @RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-mm-dd HH:mm:ss")Timestamp endMinDate, @RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-mm-dd HH:mm:ss")Timestamp endMaxDate,@RequestParam(required = false)Long product,@RequestParam(required = false)Long category,@RequestParam(required = false)Double price,@RequestParam(required = false)Integer status) throws CustomException{
        Criteria criteria=new Criteria();
        criteria.setKeyword(keyword);
        criteria.setStartMinDate(startMinDate);
        criteria.setStartMaxDate(startMaxDate);
        criteria.setEndMinDate(endMinDate);
        criteria.setEndMaxDate(endMaxDate);
        criteria.setProduct(product);
        criteria.setCategory(category);
        criteria.setPrice(price);
        criteria.setStatus(status);
        return ControllerUtil.returnSuccess(this.service.findByCriteria(criteria),HttpStatus.OK);
    }
}

