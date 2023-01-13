package com.management.auction.controllers;

import com.management.auction.models.Produit;
import com.management.auction.services.ProduitService;
import custom.springutils.controller.CrudController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/produit")
public class ProduitController extends CrudController<Produit, ProduitService> {
    public ProduitController(ProduitService service) {
        super(service);
    }
}
