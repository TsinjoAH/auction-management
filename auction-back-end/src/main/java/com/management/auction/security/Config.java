package com.management.auction.security;

import com.management.auction.services.admin.AdminLoginService;
import com.management.auction.services.user.UserLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class Config {
    @Autowired
    private AdminLoginService admin;
    @Autowired
    private UserLoginService user;
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        PreFilter preFilter=new PreFilter(admin,user);
        httpSecurity.csrf().disable().sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        httpSecurity
                .addFilter(preFilter)
                .authorizeHttpRequests(
                        (auhtz)->
                                auhtz.requestMatchers(HttpMethod.POST,"/categories/**","/products/**","/stats/**").hasAuthority("ROLE_ADMIN")
                                .requestMatchers(HttpMethod.PUT,"/categories/**","/products/**","/stats/**","/deposits/**").hasAuthority("ROLE_ADMIN")
                                .requestMatchers(HttpMethod.DELETE,"/categories/**","/products/**","**/stats/**").hasAuthority("ROLE_ADMIN")
                                .requestMatchers(HttpMethod.POST,"/users/login","/admin/login","/admin","/users").permitAll()
                                .requestMatchers(HttpMethod.DELETE,"/users/logout","/admin/logout").permitAll()
                                .anyRequest().hasAuthority("ROLE_USER")
                ).httpBasic();
        return httpSecurity.build();
    }
}
