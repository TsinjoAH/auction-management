package com.management.auction.controllers;

import com.management.auction.services.StatService;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Date;

@RestController
@RequestMapping("/stats")
public class StatController {
    private StatService service;
    public StatController(StatService service){
        this.service=service;
    }
    @GetMapping("/perday")
    public ResponseEntity<SuccessResponse> getPerDayOf(@RequestParam Date min, @RequestParam Date max){
        return ControllerUtil.returnSuccess(service.getAuctionPerDayOf(min,max), HttpStatus.OK);
    }
    @GetMapping("/commissionperday")
    public ResponseEntity<SuccessResponse> getCommissionPerDayOf(@RequestParam Date min, @RequestParam Date max){
        return ControllerUtil.returnSuccess(service.getCommissionPerDayOf(min,max), HttpStatus.OK);
    }
    @GetMapping("/totalIncrease")
    public ResponseEntity<SuccessResponse> getTotalAndIncrease(){
        return ControllerUtil.returnSuccess(service.getTotalAndRatingIncrease(),HttpStatus.OK);
    }
    @GetMapping("/usertotalIncrease")
    public ResponseEntity<SuccessResponse> getUserTotalAndIncrease(){
        return ControllerUtil.returnSuccess(service.getUserTotalAndRatingIncrease(),HttpStatus.OK);
    }
    @GetMapping("/commissiontotalIncrease")
    public ResponseEntity<SuccessResponse> getCommissionTotalAndIncrease(){
        return ControllerUtil.returnSuccess(service.getCommissionTotalAndRatingIncrease(),HttpStatus.OK);
    }
    @GetMapping("/userauction")
    public ResponseEntity<SuccessResponse> getUserAuction(){
        return ControllerUtil.returnSuccess(service.getUserAuctionCount(),HttpStatus.OK);
    }
    @GetMapping("/usersale")
    public ResponseEntity<SuccessResponse> getUserSale(){
        return ControllerUtil.returnSuccess(service.getUserSalesCount(),HttpStatus.OK);
    }
    @GetMapping("/productRating")
    public ResponseEntity<SuccessResponse> getProductRating(){
        return ControllerUtil.returnSuccess(service.getProductCountRating(),HttpStatus.OK);
    }
    @GetMapping("/categoryRating")
    public ResponseEntity<SuccessResponse> getCategoryRating(){
        return ControllerUtil.returnSuccess(service.getCategoryCountRating(),HttpStatus.OK);
    }
    @GetMapping("/productCommission")
    public ResponseEntity<SuccessResponse> getProductCommission(){
        return ControllerUtil.returnSuccess(service.getProductCommission(),HttpStatus.OK);
    }
    @GetMapping("/categoryCommission")
    public ResponseEntity<SuccessResponse> getCategoryCommission(){
        return ControllerUtil.returnSuccess(service.getCategoryCommission(),HttpStatus.OK);
    }
    @GetMapping("/productRatio/{idProduct}")
    public ResponseEntity<SuccessResponse> getProductRatio(@PathVariable Long idProduct){
        return ControllerUtil.returnSuccess(service.getProductRatio(idProduct),HttpStatus.OK);
    }
    @GetMapping("/productbid")
    public ResponseEntity<SuccessResponse> getProductBid(){
        return ControllerUtil.returnSuccess(service.getProductBid(),HttpStatus.OK);
    }
    @GetMapping("/categorybid")
    public ResponseEntity<SuccessResponse> getCategoryBid(){
        return ControllerUtil.returnSuccess(service.getCategoryBid(),HttpStatus.OK);
    }
}
