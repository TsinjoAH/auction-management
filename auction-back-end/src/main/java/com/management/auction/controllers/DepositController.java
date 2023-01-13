package com.management.auction.controllers;

import com.management.auction.models.Deposit;
import com.management.auction.models.User;
import com.management.auction.services.DepositService;
import com.management.auction.services.user.UserService;
import custom.springutils.controller.CrudWithFK;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/{fkId}/deposits")
public class DepositController extends CrudWithFK<User, UserService, Deposit, DepositService> {

    public DepositController(DepositService service, UserService fkService) {
        super(service, fkService);
    }
    @PutMapping("/{id}/validate")
    public ResponseEntity<SuccessResponse> validate(@PathVariable Long id){
        return ControllerUtil.returnSuccess(this.service.validate(id), HttpStatus.OK);
    }
}
