package com.management.auction.services;

import com.management.auction.models.Deposit;
import com.management.auction.models.User;
import com.management.auction.repos.DepositRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudServiceWithFK;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class DepositService extends CrudServiceWithFK<Deposit, User, DepositRepo> {

    @Autowired
    NotifService notifService;

    public DepositService(DepositRepo repo) {
        super(repo);
    }

    public Deposit validate(Long id) throws CustomException {
        Deposit obj=this.findById(id);
        if (obj == null ) throw new CustomException("invalid deposit");
        obj.setStatus(20);
        obj.setStatusChangeDate(Timestamp.valueOf(LocalDateTime.now()));
        Deposit dep = this.repo.save(obj);
        notifService.scheduleForDeposit(dep);
        return dep;
    }

    public List<Deposit> notValidated () {
        return this.repo.findByStatus(0);
    }

    @Override
    public List<Deposit> findForFK(User user) {
        return this.repo.findByUserId(user.getId());
    }

    public Deposit reject(Long id) throws CustomException {
        Deposit deposit = this.findById(id);
        if (deposit == null ) throw new CustomException("invalid deposit");
        deposit.setStatus(10);
        deposit.setStatusChangeDate(Timestamp.valueOf(LocalDateTime.now()));
        this.update(deposit);
        notifService.scheduleForDeposit(deposit);
        return deposit;
    }

    public List<Deposit> findForFkPageable(Long user,int page){
        return this.repo.findByUserIdOrderByIdDesc(user, PageRequest.of(page,5)).toList();
    }
    
}
