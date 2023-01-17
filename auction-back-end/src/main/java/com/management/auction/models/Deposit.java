
package com.management.auction.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.*;

import java.sql.Date;
import java.sql.Timestamp;

@Entity
@Table(name = "account_deposit")
public class Deposit extends HasFK<User> {

    @ManyToOne
    @JoinColumn(name = "user_id")
    User user;

    @Column
    double amount;

    @Column
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    Integer status = 0;

    @Column
    Date approvalDate;

    @Column
    Timestamp date;

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Date approvalDate) {
        this.approvalDate = approvalDate;
    }

    @Override
    public void setFK(User user) throws CustomException {
        if(user!=null){
            this.user=user;
        }else {
            throw new CustomException("User not found");
        }
    }

}
