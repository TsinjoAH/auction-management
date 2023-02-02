package com.management.auction.controllers;

import com.management.auction.models.Notif;
import com.management.auction.services.NotifService;
import custom.springutils.controller.CrudController;
import custom.springutils.util.ControllerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notifs")
public class NotifController {
    @Autowired
    protected NotifService service;
    public NotifController(NotifService service) {
        this.service = service;
    }
    @GetMapping("")
    public ResponseEntity<?> getAll(){
        return ControllerUtil.returnSuccess(service.getAll(), HttpStatus.OK);
    }
    @PostMapping("")
    public ResponseEntity<?> save(@RequestBody Notif notif){
        return ControllerUtil.returnSuccess(service.save(notif),HttpStatus.OK);
    }
}
