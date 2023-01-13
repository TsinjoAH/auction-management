package com.management.auction.models;

import com.management.auction.models.common.HasID;
import jakarta.persistence.*;
/*
This class can be changed but if you want to delete it or change the classname, don't forget to change the fk
in the class Deposit, the repo class and the service class
Thanks
 */
@Entity
@Table(name = "\"user\"")
public class User implements HasID {
    @Id
    @SequenceGenerator(name = "user_id",sequenceName = "user_id_seq",allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "user_id")
    Long id;
    @Column
    String name;
    @Column
    String email;
    @Column
    String password;
    @Column
    String signup_date;

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

    public String getSignup_date() {
        return signup_date;
    }

    public void setSignup_date(String signup_date) {
        this.signup_date = signup_date;
    }

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
