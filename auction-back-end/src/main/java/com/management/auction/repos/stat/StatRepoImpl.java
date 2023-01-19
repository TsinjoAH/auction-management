package com.management.auction.repos.stat;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.persistence.Tuple;
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
