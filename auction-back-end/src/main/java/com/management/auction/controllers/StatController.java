package com.management.auction.controllers;

import com.management.auction.services.StatService;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
}
