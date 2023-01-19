package com.management.auction.services;

import com.management.auction.repos.stat.StatRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;

@Service
public class StatService {
    @Autowired
    private StatRepo repo;
    public List<HashMap<String,Object>> getAuctionPerDayOf(Date min, Date max){
        return this.repo.getAuctionPerDayBetween(min,max);
    }
    public List<HashMap<String,Object>> getCommissionPerDayOf(Date min, Date max){
        return this.repo.getCommissionPerDayBetween(min,max);
    }
}
