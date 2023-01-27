package com.management.auction.models.token;

import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Setter
@Getter
@MappedSuperclass
public class TokenBase {

    @Id
    private String token;

    @Column
    private Timestamp expirationDate;

    @Column
    private boolean validity = true;

    public boolean getValidity() {
        return validity;
    }
}
