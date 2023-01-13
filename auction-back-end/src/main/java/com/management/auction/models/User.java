package com.management.auction.models;

import jakarta.persistence.*;
import custom.springutils.model.HasId;
/*
This class can be changed but if you want to delete it or change the classname, don't forget to change the fk
in the class Deposit, the repo class and the service class
Thanks
- Lars Ratovo.
 */
@Entity
@Table(name = "\"user\"")
public class User extends HasId {
    @Column
    String name;
    @Column
    String email;
    @Column
    String password;
    @Column
    String signupDate;

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
        this.password = password;
    }

    public String getSignupDate() {
        return signupDate;
    }

    public void setSignupDate(String signupDate) {
        this.signupDate = signupDate;
    }
}
