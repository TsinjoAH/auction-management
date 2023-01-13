package com.management.auction.models;

import com.management.auction.models.auction.Auction;
import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@Entity
public class Bid extends HasFK<Auction> {

    @Column
    private Integer auctionId;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    @Column
    private Double amount;
    @Column
    private Timestamp bidDate;
    @Override
    public void setFK(Auction auction) {
    }
}
