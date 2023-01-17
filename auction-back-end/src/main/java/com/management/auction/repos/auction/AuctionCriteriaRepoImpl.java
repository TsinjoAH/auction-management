package com.management.auction.repos.auction;

import com.management.auction.models.Criteria;
import com.management.auction.models.auction.Auction;
import custom.springutils.exception.CustomException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

import java.util.List;

public class AuctionCriteriaRepoImpl implements AuctionCriteriaRepo{
    @PersistenceContext
    private EntityManager manager;
    @Override
    public List<Long> getByCriteria(Criteria criteria) throws CustomException {
        String sql="SELECT id FROM full_v_auction WHERE 1=1";
        if(criteria!=null){
            if(criteria.getKeyword()!=null){
                sql+=" AND  (UPPER(title) LIKE UPPER('%s') OR UPPER(description) LIKE UPPER('%s') OR UPPER(name) LIKE UPPER('%s') OR UPPER(category) LIKE UPPER('%s'))";
                String tmp="%"+criteria.getKeyword()+"%";
                sql=String.format(sql,tmp,tmp,tmp,tmp);
            }
            if(criteria.getCategory()!=null){
                sql+=" AND category_id="+criteria.getCategory().getId().toString();
            }
            if(criteria.getPrix()!=null){
                sql+=" AND start_price="+criteria.getPrix().toString();
            }
            if(criteria.getMinTime()!=null){
                sql+=" AND start_date >= '"+criteria.getMinTime().toString()+"'";
            }
            if(criteria.getMaxTime()!=null){
                sql+=" AND start_date <= '"+criteria.getMaxTime().toString()+"'";
            }if(criteria.getState()!=null){
                sql+=" AND status = "+criteria.getState().toString();
            }
            Query q=manager.createNativeQuery(sql);
            return q.getResultList();
        }
        throw new CustomException("CRITERIA IS NULL");
    }
}
