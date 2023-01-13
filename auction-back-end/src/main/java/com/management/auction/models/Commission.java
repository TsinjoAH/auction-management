package com.management.auction.models;

import custom.springutils.model.HasId;
import jakarta.persistence.*;

import java.sql.Date;
import java.time.LocalDate;

@Entity
public class Commission extends HasId {
    @Column
    double rate;
    @Column
    Date set_date=Date.valueOf(LocalDate.now());
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

}
