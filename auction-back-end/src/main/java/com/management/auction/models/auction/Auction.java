package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import custom.springutils.exception.CustomException;
import jakarta.persistence.*;

import java.sql.Timestamp;
import java.util.List;


@Entity
public class Auction extends AuctionBase{
    @Transient
    private List<Bid> bids;

    public List<Bid> getBids() {
        return bids;
    }

    public void setBids(List<Bid> bids) {
        this.bids = bids;
    }
}
