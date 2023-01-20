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
    @GetMapping("/product/{page}")
    public ResponseEntity<SuccessResponse> getProductStat(@PathVariable int page){
        return ControllerUtil.returnSuccess(service.getStatProduct(page),HttpStatus.OK);
    }
    @GetMapping("/category/{page}")
    public ResponseEntity<SuccessResponse> getCategoryStat(@PathVariable int page){
        return ControllerUtil.returnSuccess(service.getStatCategroy(page),HttpStatus.OK);
    }
}
