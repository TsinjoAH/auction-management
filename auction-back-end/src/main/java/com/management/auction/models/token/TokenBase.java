package com.management.auction.models.token;

import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.Date;

@Setter
@Getter
public class TokenBase {

    private String token;

    private Date expirationDate;
    private boolean validity = true;

    public boolean getValidity() {
        return validity;
    }
}
