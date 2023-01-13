package com.management.auction.responses;

public class ErrorDisplay {

    private Integer code;
    private String message;

    public ErrorDisplay(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

    public ErrorDisplay() {
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
