package com.management.auction.controllers;

import com.management.auction.models.Product;
import com.management.auction.services.ProductService;
import custom.springutils.controller.CrudController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/products")
public class ProductController extends CrudController<Product, ProductService> {
    public ProductController(ProductService service) {
        super(service);
    }
}
