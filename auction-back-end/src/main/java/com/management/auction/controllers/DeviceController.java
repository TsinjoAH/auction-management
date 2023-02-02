package com.management.auction.controllers;

import com.management.auction.models.UserDevice;
import com.management.auction.services.DeviceService;
import custom.springutils.exception.CustomException;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import static custom.springutils.util.ControllerUtil.returnSuccess;

@RestController
public class DeviceController {

    @Autowired
    DeviceService service;

    @PutMapping("/users/{id}/devices")
    public ResponseEntity<?> register (@RequestBody UserDevice device, @PathVariable Long id) throws CustomException {
        device.setUserId(id);
        return returnSuccess(this.service.register(device), HttpStatus.OK);
    }

}
