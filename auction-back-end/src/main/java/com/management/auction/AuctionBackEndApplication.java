package com.management.auction;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
@EnableMongoRepositories(basePackageClasses = {com.management.auction.repos.NotifRepo.class})
public class AuctionBackEndApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuctionBackEndApplication.class, args);
    }


}
