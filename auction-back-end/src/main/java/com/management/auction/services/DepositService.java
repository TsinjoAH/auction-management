package com.management.auction.services;

import com.management.auction.models.Deposit;
import com.management.auction.models.User;
import com.management.auction.repos.DepositRepo;
import custom.springutils.service.CrudServiceWithFK;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Service
public class DepositService extends CrudServiceWithFK<Deposit, User, DepositRepo> {
    public DepositService(DepositRepo repo) {
        super(repo);
    }
    public Deposit validate(Long id){
        Deposit obj=this.findById(id);
        obj.setApproved(true);
        obj.setApprovalDate(Date.valueOf(LocalDate.now()));
        return this.repo.save(obj);
    }

    public List<Deposit> notValidated () {
        return this.repo.findByApprovedIsFalse();
    }

    @Override
    public List<Deposit> findForFK(User user) {
        return this.repo.findByUserId(user.getId());
    }
}
