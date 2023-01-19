package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import java.util.List;


@Table(name = "v_auction")
@Entity
public class AuctionView extends AuctionBase{

    @OneToMany(mappedBy = "auctionId")
    List<Bid> bids;

    @Column
    private Integer status;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public List<Bid> getBids() {
        return bids;
    }

    public void setBids(List<Bid> bids) {
        this.bids = bids;
    }
}
