package com.management.auction.models.auction;

import com.management.auction.models.ImgReceiver;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class AuctionReceiver {
    private Auction auction;
    private ImgReceiver[] images;

    public List<AuctionPic> getAuctionPics() throws IOException {
        List<AuctionPic> auctionPics = new ArrayList<>();
        for (ImgReceiver image : images) {
            AuctionPic auctionPic = new AuctionPic();
            auctionPic.setAuctionId(auction.getId());
            auctionPic.setPicPath(image.toFile());
            auctionPics.add(auctionPic);
        }
        return auctionPics;
    }


    public Auction getAuction() {
        return auction;
    }

    public void setAuction(Auction auction) {
        this.auction = auction;
    }

    public ImgReceiver[] getImages() {
        return images;
    }

    public void setImages(ImgReceiver[] images) {
        this.images = images;
    }
}
