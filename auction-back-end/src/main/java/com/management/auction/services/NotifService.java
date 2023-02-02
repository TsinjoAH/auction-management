package com.management.auction.services;

import com.management.auction.models.Notif;
import com.management.auction.repos.NotifRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotifService {
    @Autowired
    protected NotifRepo repo;
    public List<Notif> getAll(){
        return this.repo.findAll();
    }
    public Notif save(Notif notif){
        return repo.save(notif);
    }
}
