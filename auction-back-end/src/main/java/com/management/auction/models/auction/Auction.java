package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import jakarta.persistence.*;

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
