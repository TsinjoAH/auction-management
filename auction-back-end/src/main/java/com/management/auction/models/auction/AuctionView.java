package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;


@Table(name = "v_auction")
@Entity
public class AuctionView extends AuctionBase{
    @Column
    private String status;


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
