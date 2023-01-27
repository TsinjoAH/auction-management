package com.management.auction.controllers;

import com.management.auction.models.Admin;
import com.management.auction.services.admin.AdminLoginService;
import custom.springutils.controller.LoginController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin")
public class AdminController extends LoginController<Admin, AdminLoginService> {

    public AdminController(AdminLoginService service) {
        super(service);
    }

    @Override
    public String getRequestHeaderKey() {
            return "tk";
    }
}
