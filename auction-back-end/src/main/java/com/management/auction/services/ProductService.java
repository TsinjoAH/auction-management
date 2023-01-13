package com.management.auction.services;

import com.management.auction.models.Product;
import com.management.auction.repos.ProductRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class ProductService extends CrudService<Product, ProductRepo> {
    public ProductService(ProductRepo repo) {
        super(repo);
    }
}
