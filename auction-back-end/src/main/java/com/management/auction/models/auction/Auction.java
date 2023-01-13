package com.management.auction.models.auction;

import custom.springutils.exception.CustomException;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;

import java.sql.Timestamp;


@Entity
public class Auction extends AuctionBase{
    @Column
    private Long duration;

    public Long getDuration() {
        return duration;
    }

    public void setDuration(Long duration) throws CustomException {
        this.duration = duration;
        if(this.getStartDate()==null){
            throw new CustomException("Start Date is null");
        }else {
            this.setEndDate(Timestamp.valueOf(this.getStartDate().toLocalDateTime().plusMinutes(this.duration)));
        }
    }

}
