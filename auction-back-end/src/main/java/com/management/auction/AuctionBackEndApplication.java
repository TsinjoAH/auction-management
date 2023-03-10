package com.management.auction;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
public class AuctionBackEndApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuctionBackEndApplication.class, args);
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(org.springframework.web.servlet.config.annotation.CorsRegistry registry) {
                registry.addMapping("/**").allowedOrigins("http://localhost:4200", "https://63cac18440bf1c699fa92969--transcendent-crostata-3faff3.netlify.app").allowedMethods("*").allowedHeaders("*");
                registry.addMapping("/**").allowedOrigins("*").allowedMethods("*").allowedHeaders("*");
            }
        };
    }

}
