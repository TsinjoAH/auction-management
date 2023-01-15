package com.management.auction.repos.auction;

import com.management.auction.models.Criteria;
import com.management.auction.models.auction.Auction;
import custom.springutils.exception.CustomException;

import java.util.List;

public interface AuctionCriteriaRepo {
    List<Long> getByCriteria(Criteria criteria) throws CustomException;
}
