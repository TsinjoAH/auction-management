package com.management.auction.models;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import java.sql.Date;
import java.sql.Timestamp;
/*
VIEW full_v_criteria

 */
@Component
public class Criteria {
    String keyword;
    Timestamp minTime;
    Timestamp maxTime;
    Category category;
    Integer state;
    Double prix;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Timestamp getMinTime() {
        return minTime;
    }

    public void setMinTime(Timestamp minTime) {
        this.minTime = minTime;
    }

    public Timestamp getMaxTime() {
        return maxTime;
    }

    public void setMaxTime(Timestamp maxTime) {
        this.maxTime = maxTime;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Double getPrix() {
        return prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }
}
