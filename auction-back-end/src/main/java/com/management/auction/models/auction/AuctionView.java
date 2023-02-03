package com.management.auction.models.auction;

import com.management.auction.models.Bid;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import org.hibernate.annotations.Formula;

import java.util.List;


@Table(name = "v_auction")
@Entity
public class AuctionView extends AuctionBase{
    @Column
    private Integer status;
    @Formula(("SELECT b.user_id FROM bid b WHERE b.id = id AND amount = (SELECT va.amount FROM v_auction_winner_amount va WHERE va.id=1)"))
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
