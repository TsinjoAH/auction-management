package com.management.auction.repos.stat;

import jakarta.persistence.*;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
@Repository
public class StatRepoImpl implements StatRepo{
    @PersistenceContext
    EntityManager manager;
    @Override
    public List<HashMap<String,Object>> getAuctionPerDayBetween(Date min, Date max) {
        String sql="SELECT * FROM auctionperday WHERE date >= ? AND date <= ?";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        query.setParameter(1,min);
        query.setParameter(2,max);
        List<Tuple> data=query.getResultList();
        List<HashMap<String,Object>> result=listOfTupleToMap(data,"count","date");
        return result;
    }

    @Override
    public List<HashMap<String, Object>> getCommissionPerDayBetween(Date min, Date max) {
        String sql="SELECT * FROM commission_per_day WHERE date >= ? AND date <= ?";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        query.setParameter(1,min);
        query.setParameter(2,max);
        return listOfTupleToMap(query.getResultList(),"commission","date");
    }

    @Override
    public HashMap<String, Object> getTotalAndIncrease() {
        String sql="SELECT * FROM rating_month";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        try {
            return this.tupleToMap((Tuple) query.getSingleResult(),"total","increaserate");
        }catch (NoResultException ex){
            HashMap<String,Object> map=new HashMap<String,Object>();
            map.put("total",0);
            map.put("increaserate",0);
            return map;
        }
    }

    @Override
    public HashMap<String, Object> getUserTotalAndIncrease() {
        String sql="SELECT * FROM rating_user";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return this.tupleToMap((Tuple) query.getSingleResult(),"usercount","increaserate");
    }

    @Override
    public HashMap<String, Object> getCommissionTotalAndIncrease() {
        String sql="SELECT * FROM rating_commisison";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return this.tupleToMap((Tuple) query.getSingleResult(),"totalcommission","increaserate");
    }

    @Override
    public List<HashMap<String, Object>> getUserAuctionCount() {
        String sql="SELECT auctioncount,user_id user,rate FROM rating_user_auction";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"auctioncount","user","rate");
    }

    @Override
    public List<HashMap<String, Object>> getUserSalesCount() {

        String sql=" SELECT * FROM rating_user_sale";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"user","sales","commission","rate");
    }

    @Override
    public List<HashMap<String, Object>> getProductCountRating() {

        String sql=" SELECT * FROM count_rating_product";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"salescount","product","rate");
    }

    @Override
    public List<HashMap<String, Object>> getCategoryCountRating() {
        String sql=" SELECT * FROM count_rating_category";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"salescount","category","rate");
    }

    @Override
    public List<HashMap<String, Object>> getProductCommission() {

        String sql=" SELECT * FROM product_commission";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"sales","product","commission","rate");
    }

    @Override
    public List<HashMap<String, Object>> getCategoryCommission() {

        String sql=" SELECT * FROM category_commission";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"sales","category","commission","rate");
    }

    @Override
    public List<HashMap<String, Object>> getProductRatio(Long product) {
        String sql=" SELECT * FROM product_ratio WHERE product = ?";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        query.setParameter(1,product);
        return listOfTupleToMap(query.getResultList(),"date","ratio");
    }

    @Override
    public List<HashMap<String, Object>> getProductBid() {
        String sql=" SELECT * FROM product_bid_count";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"bidcount","product");
    }

    @Override
    public List<HashMap<String, Object>> getCategoryBid() {
        String sql=" SELECT * FROM category_bid_count";
        Query query=manager.createNativeQuery(sql, Tuple.class);
        return listOfTupleToMap(query.getResultList(),"bidcount","category");
    }

    private HashMap<String,Object> tupleToMap(Tuple tuple,String... keys){
        HashMap<String,Object> result=new HashMap<>();
        for(String key:keys){
            result.put(key,tuple.get(key));
        }
        return result;
    }
    private List<HashMap<String,Object>> listOfTupleToMap(List<Tuple> list,String... keys){
        List<HashMap<String,Object>> result=new ArrayList<>();
        for(Tuple tuple:list){
            result.add(tupleToMap(tuple,keys));
        }
        return result;
    }
}
