package com.management.auction.controllers;

import com.management.auction.services.NotifService;
import custom.springutils.util.ControllerUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users/{fkId}/notifications")
public class NotificationsController {

    protected NotifService service;

    public NotificationsController(NotifService service) {
        this.service = service;
    }

    @GetMapping("")
    public ResponseEntity<?> getAll(@PathVariable Long fkId){
        return ControllerUtil.returnSuccess(service.findNotifications(fkId), HttpStatus.OK);
    }

}
