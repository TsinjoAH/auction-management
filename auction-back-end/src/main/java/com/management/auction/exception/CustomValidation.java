package com.management.auction.exception;

public class CustomValidation extends Exception {

    public CustomValidation() {
    }

    public CustomValidation(String s) {
        super(s);
    }

    public CustomValidation(String s, Throwable throwable) {
        super(s, throwable);
    }

    @Override
    public String toString() {
        return "{ \"message\": " +
                getMessage() +
                " }";
    }
}
