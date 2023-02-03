package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import jakarta.persistence.*;
import org.hibernate.annotations.Formula;

import java.util.List;


@Table(name = "v_auction")
@Entity
public class AuctionView extends AuctionBase{
    @Column
    private Integer status;
    @Formula("(SELECT b.user_id FROM bid b WHERE b.auction_id=id AND b.amount=(SELECT max(v.amount) FROM bid v WHERE v.auction_id=id))")
    private Long winner;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Long getWinner() {
        return winner;
    }

    public void setWinner(Long winner) {
        this.winner = winner;
    }
}
