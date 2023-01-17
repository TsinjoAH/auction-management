package com.management.auction.controllers.deposit;

import com.management.auction.services.DepositService;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("deposits")
public class DepositController {

    @Autowired
    DepositService service;

    @PutMapping("/{id}/validate")
    public ResponseEntity<SuccessResponse> validate(@PathVariable Long id){
        return ControllerUtil.returnSuccess(this.service.validate(id), HttpStatus.OK);
    }

    @GetMapping("/not-validated")
    public ResponseEntity<?> notValidated () {
        return ControllerUtil.returnSuccess(this.service.notValidated(), HttpStatus.OK);
    }
}
