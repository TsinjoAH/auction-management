package com.management.auction.repos.auction;

import com.management.auction.models.Criteria;
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
                sql+=" AND  (UPPER(title) LIKE UPPER('%s') OR UPPER(description) LIKE UPPER('%s') OR UPPER(product) LIKE UPPER('%s') OR UPPER(category) LIKE UPPER('%s'))";
                String tmp="%"+criteria.getKeyword()+"%";
                sql=String.format(sql,tmp,tmp,tmp,tmp);
            }
            if(criteria.getCategory()!=null){
                sql+=" AND category_id="+criteria.getCategory().toString();
            }if(criteria.getProduct()!=null){
                sql+=" AND product_id="+criteria.getProduct().toString();
            }if(criteria.getPrice()!=null){
                sql+=" AND start_price="+criteria.getPrice().toString();
            }if(criteria.getStartMinDate()!=null){
                sql+=" AND start_date >= '"+criteria.getStartMinDate().toString()+"'";
            }if(criteria.getStartMaxDate()!=null){
                sql+=" AND start_date <= '"+criteria.getStartMaxDate().toString()+"'";
            }if(criteria.getEndMinDate()!=null){
                sql+=" AND end_date >= '"+criteria.getEndMinDate().toString()+"'";
            }if(criteria.getEndMaxDate()!=null){
                sql+=" AND end_date <= '"+criteria.getEndMaxDate().toString()+"'";
            }if(criteria.getStatus()!=null){
                sql+=" AND status = "+criteria.getStatus().toString();
            }if(criteria.getPrice()!=null){
                sql+=" AND start_price <= "+criteria.getPrice().toString();
            }
            Query q=manager.createNativeQuery(sql);
            return q.getResultList();
        }
        throw new CustomException("CRITERIA IS NULL");
    }
}
