package com.management.auction.models.token;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "userToken")
public class UserToken extends TokenBase{

    private Long userId;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
