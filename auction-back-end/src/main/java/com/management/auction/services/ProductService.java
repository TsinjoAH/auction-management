package com.management.auction.services;

import com.management.auction.models.Product;
import com.management.auction.repos.ProductRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService extends CrudService<Product, ProductRepo> {
    public ProductService(ProductRepo repo) {
        super(repo);
    }

    public List<Product> findByName(String name){
        if (name == null || name.isEmpty()) return repo.findAll();
        return this.repo.findByNameIsLikeIgnoreCase("%"+name+"%");
    }
}
