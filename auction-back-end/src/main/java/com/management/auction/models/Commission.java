package com.management.auction.models;

import com.management.auction.models.common.HasID;
import custom.springutils.model.HasId;
import jakarta.persistence.*;

import java.sql.Date;

@Entity
public class Commission implements HasID {
    @Column
    @Id
    @SequenceGenerator(name = "commission_id_seq",sequenceName = "commission_id_seq",allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "commission_id_seq")
    Long id;
    @Column
    double rate;
    @Column
    Date set_date;
    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public Date getSet_date() {
        return set_date;
    }

    public void setSet_date(Date set_date) {
        this.set_date = set_date;
    }

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
