package com.management.auction.controllers;

import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.services.AuctionService;
import com.management.auction.services.UserService;
import custom.springutils.controller.CrudWithFK;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/{fkId}/auctions")
public class AuctionController extends CrudWithFK<User, UserService, Auction, AuctionService>{
    public AuctionController(AuctionService service, UserService fkService) {
        super(service, fkService);
    }

}
