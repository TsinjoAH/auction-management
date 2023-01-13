package com.management.auction.services.admin;

import com.management.auction.models.Admin;
import com.management.auction.repos.AdminRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class AdminService extends CrudService<Admin, AdminRepo> {

    public AdminService(AdminRepo repo) {
        super(repo);
    }
}
