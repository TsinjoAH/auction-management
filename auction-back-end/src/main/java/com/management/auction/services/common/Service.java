package com.management.auction.services.common;


import com.management.auction.exception.CustomValidation;

public interface Service <E> {

    E create(E obj) throws CustomValidation;

    E update(E obj) throws CustomValidation;

    void delete(Long id);

    E findById(Long id);

    Iterable<E> findAll();

}
