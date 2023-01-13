package com.management.auction.controllers;

import com.management.auction.controllers.common.CrudWithFK;
import com.management.auction.models.Deposit;
import com.management.auction.models.User;
import com.management.auction.responses.Success;
import com.management.auction.services.DepositService;
import com.management.auction.services.UserService;
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
    public ResponseEntity<Success> validate(@PathVariable Long id){
        return CrudWithFK.returnSuccess(this.service.validate(id), HttpStatus.OK);
    }
}
