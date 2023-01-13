package com.management.auction.models.token;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class AdminToken extends TokenBase{
    @Column
    private Long adminId;

    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }
}
