package com.management.auction.controllers.deposit;

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
public class UserDepositController extends CrudWithFK<User, UserService, Deposit, DepositService> {

    public UserDepositController(DepositService service, UserService fkService) {
        super(service, fkService);
    }

}
