package com.management.auction.controllers.common;

import com.management.auction.exception.CustomValidation;
import com.management.auction.models.common.HasFK;
import com.management.auction.responses.Success;
import com.management.auction.services.common.Service;
import com.management.auction.services.common.ServiceWithFK;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
public class CrudWithFK <FK, FKS extends Service<FK>, E extends HasFK<FK>, S extends ServiceWithFK<E, FK>> {

    private final S service;
    private final FKS fkService;

    public CrudWithFK(S service, FKS fkService) {
        this.service = service;
        this.fkService = fkService;
    }

    @PostMapping("")
    public ResponseEntity<Success> create (@PathVariable Long fkId, @RequestBody @Valid E obj) throws CustomValidation {
        FK fk = this.fkService.findById(fkId);
        obj.setFK(fk);
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
    public ResponseEntity<Success> findAll(@PathVariable Long fkId) {
        FK fk = this.fkService.findById(fkId);
        return returnSuccess(service.findForFK(fk), HttpStatus.OK);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Success> update(@PathVariable Long fkId, @PathVariable("id") Long id, @RequestBody @Valid E obj) throws CustomValidation {
        FK fk = this.fkService.findById(fkId);
        obj.setId(id);
        obj.setFK(fk);
        return returnSuccess(service.update(obj), HttpStatus.OK);
    }

    public static ResponseEntity<Success> returnSuccess(Object obj, HttpStatus status) {
        return new ResponseEntity<Success>(new Success(obj), status);
    }
}
