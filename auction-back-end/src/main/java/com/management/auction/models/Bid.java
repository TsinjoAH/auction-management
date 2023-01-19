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
import java.time.LocalDateTime;
import java.util.Objects;

@Getter
@Setter
@Entity
public class Bid extends HasFK<Auction> {
    @Column
    private Long auctionId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column
    private Double amount;

    @Column
    private Timestamp bidDate = Timestamp.valueOf(LocalDateTime.now());

    @Override
    public void setFK(Auction auction) throws CustomException {
        if(auction!=null){
            if  (auction.getEndDate().compareTo(getBidDate()) < 0 ) {
                throw new CustomException("The auction already ended");
            }
            if (getUser() == null ) {
                throw new CustomException("invalid user");
            }
            if (Objects.equals(getUser().getId(), auction.getUser().getId())) {
                throw new CustomException("you cannot bid on your own auction");
            }
            this.auctionId=auction.getId();
        }
        else {
            throw new CustomException("Auction not found");
        }
    }
}
