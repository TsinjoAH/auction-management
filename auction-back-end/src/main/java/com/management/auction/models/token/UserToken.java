package com.management.auction.models.token;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class UserToken extends TokenBase{

    @Column
    private Long userId;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
