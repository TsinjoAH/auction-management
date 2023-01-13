package com.management.auction.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import custom.springutils.LoginEntity;
import jakarta.persistence.*;
import custom.springutils.model.HasId;
import org.apache.commons.codec.digest.DigestUtils;

import java.sql.Timestamp;

/*
This class can be changed but if you want to delete it or change the classname, don't forget to change the fk
in the class Deposit, the repo class and the service class
Thanks
- Lars Ratovo.
 */
@Entity
@Table(name = "\"user\"")
public class User extends HasId implements LoginEntity {

    @Column
    String name;

    @Column
    String email;

    @Column
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    String password;

    @Column
    Timestamp signupDate;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = DigestUtils.sha1Hex(password);
    }

    public Timestamp getSignupDate() {
        return signupDate;
    }

    public void setSignupDate(Timestamp signupDate) {
        this.signupDate = signupDate;
    }
}
