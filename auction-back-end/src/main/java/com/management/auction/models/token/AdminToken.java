package com.management.auction.models.token;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "adminToken")
public class AdminToken extends TokenBase{
    private Long adminId;

    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }
}
