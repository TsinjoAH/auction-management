package com.management.auction.responses;

public class AuthenticatedDetails {
    private String token;

    public AuthenticatedDetails(String token) {
        this.token = token;
    }

    public AuthenticatedDetails() {
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
