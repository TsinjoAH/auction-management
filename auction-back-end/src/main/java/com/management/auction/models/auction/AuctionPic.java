package com.management.auction.models.auction;

import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class AuctionPic extends HasFK<Auction> {
    @Column
    private Long auctionId;
    @Column
    private String picPath;
    @Override
    public void setFK(Auction auction) throws CustomException {

    }
}
