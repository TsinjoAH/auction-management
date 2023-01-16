package com.management.auction.models;

import custom.springutils.model.HasId;
import jakarta.persistence.*;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
public class Commission extends HasId {
    @Column
    double rate;

    @Column
    Timestamp setDate=Timestamp.valueOf(LocalDateTime.now());

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public Timestamp getSetDate() {
        return setDate;
    }

    public void setSetDate(Timestamp setDate) {
        this.setDate = setDate;
    }
}
