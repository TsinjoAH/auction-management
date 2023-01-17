package com.management.auction.controllers.deposit;

import com.management.auction.services.DepositService;
import custom.springutils.exception.CustomException;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static custom.springutils.util.ControllerUtil.returnSuccess;

@RestController
@RequestMapping("deposits")
public class DepositController {

    @Autowired
    DepositService service;

    @PutMapping("/{id}/validate")
    public ResponseEntity<SuccessResponse> validate(@PathVariable Long id) throws CustomException {
        return returnSuccess(this.service.validate(id), HttpStatus.OK);
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<?> reject (@PathVariable Long id) throws CustomException {
        return returnSuccess(this.service.reject(id), HttpStatus.OK);
    }

    @GetMapping("/not-validated")
    public ResponseEntity<?> notValidated () {
        return returnSuccess(this.service.notValidated(), HttpStatus.OK);
    }
}
