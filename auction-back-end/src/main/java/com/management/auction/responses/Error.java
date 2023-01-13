package com.management.auction.responses;

public class Error {
    private ErrorDisplay error;

    public Error(ErrorDisplay error) {
        this.error = error;
    }

    public ErrorDisplay getError() {
        return error;
    }

    public void setError(ErrorDisplay error) {
        this.error = error;
    }
}
