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
    Timestamp startMinDate;
    Timestamp startMaxDate;
    Timestamp endMinDate;
    Timestamp endMaxDate;
    Long product;
    Long category;
    Double price;
    Integer status;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Timestamp getStartMinDate() {
        return startMinDate;
    }

    public void setStartMinDate(Timestamp startMinDate) {
        this.startMinDate = startMinDate;
    }

    public Timestamp getStartMaxDate() {
        return startMaxDate;
    }

    public void setStartMaxDate(Timestamp startMaxDate) {
        this.startMaxDate = startMaxDate;
    }

    public Timestamp getEndMinDate() {
        return endMinDate;
    }

    public void setEndMinDate(Timestamp endMinDate) {
        this.endMinDate = endMinDate;
    }

    public Timestamp getEndMaxDate() {
        return endMaxDate;
    }

    public void setEndMaxDate(Timestamp endMaxDate) {
        this.endMaxDate = endMaxDate;
    }

    public Long getProduct() {
        return product;
    }

    public void setProduct(Long product) {
        this.product = product;
    }

    public Long getCategory() {
        return category;
    }

    public void setCategory(Long category) {
        this.category = category;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
