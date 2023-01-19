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
    public List<HashMap<String,Object>> getProductCountRating(){
        List<HashMap<String,Object>> map=this.repo.getProductCountRating();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("product",this.productrepo.findById(Long.valueOf((Integer) tmp.get("product"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getCategoryCountRating(){
        List<HashMap<String,Object>> map=this.repo.getCategoryCountRating();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("category",this.categoryRepo.findById(Long.valueOf((Integer) tmp.get("category"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getProductCommission(){
        List<HashMap<String,Object>> map=this.repo.getProductCommission();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("product",this.productrepo.findById(Long.valueOf((Integer) tmp.get("product"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getCategoryCommission(){
        List<HashMap<String,Object>> map=this.repo.getCategoryCommission();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("category",this.categoryRepo.findById(Long.valueOf((Integer) tmp.get("category"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getProductRatio(Long product){
        return this.repo.getProductRatio(product);
    }
    public List<HashMap<String,Object>> getProductBid(){
        List<HashMap<String,Object>> map=this.repo.getProductBid();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("product",this.productrepo.findById(Long.valueOf((Integer) tmp.get("product"))));
        }
        return map;
    }
    public List<HashMap<String,Object>> getCategoryBid(){
        List<HashMap<String,Object>> map=this.repo.getCategoryBid();
        for(int i=0;i<map.size();i++){
            HashMap<String,Object> tmp=map.get(i);
            tmp.replace("category",this.categoryRepo.findById(Long.valueOf((Integer) tmp.get("category"))));
        }
        return map;
    }
}
