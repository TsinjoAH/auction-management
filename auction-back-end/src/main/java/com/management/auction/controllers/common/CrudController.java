package com.management.auction.controllers.common;

import com.management.auction.exception.CustomValidation;
import com.management.auction.models.common.HasID;
import com.management.auction.responses.Success;
import com.management.auction.services.common.Service;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

public class CrudController<E extends HasID, S extends Service<E>> {

    protected final S service;

    public CrudController(S service) {
        this.service = service;
    }

    @PostMapping("")
    public ResponseEntity<Success> create(@RequestBody @Valid E obj) throws CustomValidation {
        return returnSuccess(service.create(obj), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Success> findById(@PathVariable("id") Long id) {
        return returnSuccess(service.findById(id), HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Success> delete(@PathVariable Long id) {
        service.delete(id);
        return returnSuccess("", HttpStatus.NO_CONTENT);
    }

    @GetMapping("")
    public ResponseEntity<Success> findAll() {
        return returnSuccess(service.findAll(), HttpStatus.OK);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Success> update(@PathVariable("id") Long id, @RequestBody @Valid E obj) throws CustomValidation {
        obj.setId(id);
        return returnSuccess(service.update(obj), HttpStatus.OK);
    }

    public static ResponseEntity<Success> returnSuccess(Object obj, HttpStatus status) {
        return new ResponseEntity<Success>(new Success(obj), status);
    }

}
