package com.management.auction.services.common;

import org.springframework.data.jpa.repository.JpaRepository;

public abstract class CrudServiceWithFK<E, FK,  R extends JpaRepository<E, Long>> extends CrudService<E, R> implements ServiceWithFK<E, FK> {

    public CrudServiceWithFK(R repo) {
        super(repo);
    }
}
