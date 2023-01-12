package com.management.auction.models;

import custom.springutils.LoginEntity;
import custom.springutils.model.HasName;
import jdk.nashorn.internal.objects.annotations.Getter;
import jdk.nashorn.internal.objects.annotations.Setter;


import javax.persistence.*;

@Entity
@Table(name = "users")
public class User extends HasName implements LoginEntity {

    private Long id;
    private  String email;
    private  String password;

    @Override
    @Getter
    public String getEmail() {
        return this.email;
    }

    @Setter
    public void setEmail(String email){

        this.email=email;

    }

    @Override
    @Getter
    public String getPassword() {
        return this.password;
    }

    @Setter
    public void setPassword(String password){

        this.password=password;

    }

    public void setId(Long id) {
        this.id = id;
    }

    @Id
    public Long getId() {
        return id;
    }
}
