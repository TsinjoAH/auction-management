package com.management.auction.models.auction;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;


@Table(name = "v_auction")
@Entity
public class AuctionView extends AuctionBase{
    @Column
    private Integer status;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
