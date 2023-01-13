package com.management.auction.models.auction;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.management.auction.models.Product;
import com.management.auction.models.User;
import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.time.LocalDateTime;

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
    private Timestamp startDate = Timestamp.valueOf(LocalDateTime.now());
    @Column
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Timestamp endDate;
    @ManyToOne
    private Product product;
    @Column
    private Double startPrice;
    @Column
    private Double commission;



    @Override
    public void setFK(User user) throws CustomException {
        if(user!=null){
            this.user=user;
        }else {
            throw new CustomException("User not found");
        }
    }

    public void setStartPrice(Double startPrice) throws CustomException {
        if(startPrice < 0) {
            throw new CustomException("Start Price should be positive");
        }else {
            this.startPrice = startPrice;
        }
    }
}

