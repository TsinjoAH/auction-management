package com.management.auction.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class Config {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        PreFilter preFilter=new PreFilter();
        httpSecurity.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        httpSecurity
                .addFilter(preFilter)
                .authorizeHttpRequests(
                        (auhtz)->
                                auhtz.requestMatchers(HttpMethod.POST,"/categories/?[0-9]*").hasAuthority("ROLE_ADMIN")
                                .requestMatchers(HttpMethod.PUT,"/categories/?[0-9]*").hasAuthority("ROLE_ADMIN")
                                .anyRequest().permitAll()
                );
        return httpSecurity.build();
    }
}
