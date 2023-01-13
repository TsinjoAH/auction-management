package com.management.auction.controllers;

import com.management.auction.models.auction.Auction;
import com.management.auction.models.User;
import com.management.auction.services.AuctionService;
import com.management.auction.services.user.UserService;
import custom.springutils.controller.CrudWithFK;
import custom.springutils.exception.CustomException;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/{fkId}/auctions")
public class AuctionController extends CrudWithFK<User, UserService, Auction, AuctionService>{
    public AuctionController(AuctionService service, UserService fkService) {
        super(service, fkService);
    }
    
    //No delete No Update
    @Override
    public ResponseEntity<SuccessResponse> update(Long fkId, Long id, Auction obj) throws CustomException {
        return null;
    }
    @Override
    public ResponseEntity<SuccessResponse> delete(Long id) {
        return null;
    }
}
