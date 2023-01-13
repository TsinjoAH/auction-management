package com.management.auction.models;

import com.management.auction.utils.Base64ToFile;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ImgReceiver {
    private String name;
    private String base64;

    public String toFile() throws IOException {
        String newPath = "images/"+Timestamp.valueOf(LocalDateTime.now())+name;
        newPath = newPath.replace(' ','_');
        newPath = newPath.replace(':','_');
        Base64ToFile.convert(this.base64,"public/"+newPath);
        return newPath;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBase64() {
        return base64;
    }

    public void setBase64(String base64) {
        this.base64 = base64;
    }
}
