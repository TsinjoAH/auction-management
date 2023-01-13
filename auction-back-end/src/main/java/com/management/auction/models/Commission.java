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
    Date setDate=Date.valueOf(LocalDate.now());
    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public Date getSetDate() {
        return setDate;
    }

    public void setSetDate(Date setDate) {
        this.setDate = setDate;
    }
}
