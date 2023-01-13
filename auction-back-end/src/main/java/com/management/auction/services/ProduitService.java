package com.management.auction.services;

import com.management.auction.models.Produit;
import com.management.auction.repos.ProduitRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class ProduitService extends CrudService<Produit, ProduitRepo> {

    public ProduitService(ProduitRepo repo) {
        super(repo);
    }
}
