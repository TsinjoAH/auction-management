package com.management.auction.services;

import com.management.auction.repos.CategoryRepo;
import com.management.auction.repos.ProductRepo;
import com.management.auction.repos.UserRepo;
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
    @Autowired
    private UserRepo userrepo;
    @Autowired
    private ProductRepo productrepo;
    @Autowired
    private CategoryRepo categoryRepo;
    public List<HashMap<String,Object>> getAuctionPerDayOf(Date min, Date max){
        return this.repo.getAuctionPerDayBetween(min,max);
    }
    public List<HashMap<String,Object>> getCommissionPerDayOf(Date min, Date max){
        return this.repo.getCommissionPerDayBetween(min,max);
    }
    public HashMap<String,Object> getTotalAndRatingIncrease(){
        return this.repo.getTotalAndIncrease();
    }
    public HashMap<String,Object> getUserTotalAndRatingIncrease(){
        return this.repo.getUserTotalAndIncrease();
    }
    public HashMap<String,Object> getCommissionTotalAndRatingIncrease(){
        return this.repo.getCommissionTotalAndIncrease();
    }
    public List<HashMap<String,Object>> getUserAuctionCount(){
        List<HashMap<String,Object>> map=this.repo.getUserAuctionCount();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("user",this.userrepo.findById(Long.valueOf((Integer) tmp.get("user"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getUserSalesCount(){
        List<HashMap<String,Object>> map=this.repo.getUserSalesCount();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("user",this.userrepo.findById(Long.valueOf((Integer) tmp.get("user"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getStatProduct(int page){
        return this.repo.getProductStat(page);
    }
    public List<HashMap<String,Object>> getStatCategroy(int page){
        return this.repo.getCategoryStat(page);
    }
}
