package com.management.auction.models;

import custom.springutils.model.HasId;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class UserDevice extends HasId {

    @Column
    private Long userId;

    @Column(unique = true)
    private String deviceToken;

    public String getDeviceToken() {
        return deviceToken;
    }

    public void setDeviceToken(String deviceToken) {
        this.deviceToken = deviceToken;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
