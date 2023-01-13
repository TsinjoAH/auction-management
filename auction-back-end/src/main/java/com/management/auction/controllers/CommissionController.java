package com.management.auction.controllers;

import com.management.auction.models.Commission;
import com.management.auction.services.CommissionService;
import custom.springutils.controller.CrudController;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/commission")
public class CommissionController extends CrudController<Commission, CommissionService> {

    public CommissionController(CommissionService service) {
        super(service);
    }

    @GetMapping("")
    @Override
    public ResponseEntity<SuccessResponse> findAll(){
        return ControllerUtil.returnSuccess(this.service.getLatest(), HttpStatus.OK);
    }

}
