package com.management.auction.models.auction;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.management.auction.models.Bid;
import com.management.auction.models.Product;
import com.management.auction.models.User;
import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Formula;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@MappedSuperclass
public class AuctionBase extends HasFK<User> {
    @Column
    private String title;
    @Column
    private String description;
    @ManyToOne
    private User user;

    @Column
    private Long duration;
    @Column
    private Timestamp startDate = Timestamp.valueOf(LocalDateTime.now());
    @Column
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Timestamp endDate;
    @ManyToOne
    private Product product;
    @Column
    private Double startPrice;
    
    @Column
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Double commission;
    @OneToMany(mappedBy = "auctionId")
    private List<AuctionPic> images;

    @Transient
    private List<Bid> bids;
    @Formula("(SELECT MAX(b.amount) FROM bid b WHERE b.auction_id=id)")
    private Double max=Double.valueOf(0);
    public List<Bid> getBids() {
        return bids;
    }

    public void setBids(List<Bid> bids) {
        this.bids = bids;
    }


    @Override
    public void setFK(User user) throws CustomException {
        if(user!=null){
            this.user=user;
        }else {
            throw new CustomException("User not found");
        }
    }

    public void setDuration(Long duration) throws CustomException {
        this.duration = duration;
        if(this.getStartDate()==null){
            throw new CustomException("Start Date is null");
        }else {
            this.setEndDate(Timestamp.valueOf(this.getStartDate().toLocalDateTime().plusMinutes(this.duration)));
        }
    }


    public void setStartPrice(Double startPrice) throws CustomException {
        if(startPrice < 0) {
            throw new CustomException("Start Price should be positive");
        }else {
            this.startPrice = startPrice;
        }
    }

    public Double getMax() {
        if(max!=null){
            return max;
        }else {
            return 0.0;
        }
    }
}

