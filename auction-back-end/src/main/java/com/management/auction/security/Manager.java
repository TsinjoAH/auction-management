package com.management.auction.security;

import com.management.auction.services.admin.AdminLoginService;
import com.management.auction.services.user.UserLoginService;
import custom.springutils.exception.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class Manager implements AuthenticationManager {
    private AdminLoginService admin;
    private UserLoginService user;
    public Manager(AdminLoginService admin,UserLoginService user){
        this.admin=admin;
        this.user=user;
    }
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String token=authentication.getPrincipal().toString();
        if(token!=null){
            try {
                if(admin.isConnected(token)){
                    List<GrantedAuthority> authorities=new ArrayList<>();
                    authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                    authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
                    authentication=new UsernamePasswordAuthenticationToken(token,null,authorities);
                }else if(user.isConnected(token)){
                    List<GrantedAuthority> authorities=new ArrayList<>();
                    authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
                    authentication=new UsernamePasswordAuthenticationToken(token,null,authorities);
                }
            } catch (CustomException e) {
                return authentication;
            }
        }
        return authentication;
    }
}
