
package com.management.auction.models;

import com.management.auction.exception.CustomValidation;
import com.management.auction.models.common.HasFK;
import jakarta.persistence.*;

import java.sql.Date;
@Entity
@Table(name = "account_deposit")
public class Deposit implements HasFK<User> {
    @Id
    @SequenceGenerator(name = "id_deposit",sequenceName = "account_deposit_id_seq",allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "id_deposit")
    Long id;
    @OneToOne
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
    public void setId(Long id) {
        this.id=id;
    }

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setFK(User user) throws CustomValidation {
        if(user!=null){
            this.user=user;
        }else {
            throw new CustomValidation("User not found");
        }
    }

}
