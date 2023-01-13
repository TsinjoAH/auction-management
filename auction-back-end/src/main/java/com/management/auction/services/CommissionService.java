package com.management.auction.services;

import com.management.auction.exception.CustomValidation;
import com.management.auction.models.Commission;
import com.management.auction.repos.CommissionRepo;
import com.management.auction.services.common.CrudService;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;

@Service
public class CommissionService extends CrudService<Commission, CommissionRepo>{
    public CommissionService(CommissionRepo repo) {
        super(repo);
    }
    public Commission getLatest(){
        return this.repo.getLatest();
    }

}
