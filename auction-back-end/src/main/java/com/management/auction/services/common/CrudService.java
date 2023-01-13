package com.management.auction.services.common;

import com.management.auction.exception.CustomValidation;
import org.springframework.data.jpa.repository.JpaRepository;

public class CrudService <E,  R extends JpaRepository<E, Long>> implements Service<E> {

    protected final R repo;

    public CrudService(R repo) {
        this.repo = repo;
    }

    @Override
    public E create(E obj) throws CustomValidation {
        return repo.save(obj);
    }

    @Override
    public E update(E obj) throws CustomValidation {
        return repo.save(obj);
    }

    @Override
    public void delete(Long id) {
        repo.deleteById(id);
    }

    @Override
    public E findById(Long id) {
        return repo.findById(id).orElse(null);
    }

    @Override
    public Iterable<E> findAll() {
        return repo.findAll();
    }

}
