
package com.management.auction.models;

import custom.springutils.exception.CustomException;
import custom.springutils.model.HasFK;
import jakarta.persistence.*;

import java.sql.Date;
@Entity
@Table(name = "account_deposit")
public class Deposit extends HasFK<User> {
    @ManyToOne
    @JoinColumn(name = "user_id")
    User user;
    @Column
    double amount;
    @Column
    boolean approved=false;
    @Column
    Date approval_date;

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

    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    public Date getApproval_date() {
        return approval_date;
    }

    public void setApproval_date(Date approval_date) {
        this.approval_date = approval_date;
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
