package com.management.auction.responses;

public class Success {
    private Object data;

    public Success(Object data) {
        this.data = data;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
