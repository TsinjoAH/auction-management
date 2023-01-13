package com.management.auction.models;

import custom.springutils.LoginEntity;
import custom.springutils.model.HasName;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import org.apache.commons.codec.digest.DigestUtils;

@Entity
@Table(name = "admin")
public class Admin extends HasName implements LoginEntity {
    @Column
    String name;
    @Column
    String password;
    @Column
    String email;

    public String getName()
    {
        return  name;
    }
    public void setName(String name){
        this.name=name;
    }

    @Override
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = DigestUtils.sha1Hex(password);
    }
}
