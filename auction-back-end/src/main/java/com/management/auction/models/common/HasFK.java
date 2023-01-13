package com.management.auction.models.common;


import com.management.auction.exception.CustomValidation;

public interface HasFK<FK> extends HasID{
    void setFK(FK fk) throws CustomValidation;

}
