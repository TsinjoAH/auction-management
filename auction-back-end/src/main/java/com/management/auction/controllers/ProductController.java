package com.management.auction.controllers;

import com.management.auction.models.Product;
import com.management.auction.services.ProductService;
import custom.springutils.controller.CrudController;
import custom.springutils.util.ControllerUtil;
import custom.springutils.util.SuccessResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/products")
public class ProductController extends CrudController<Product, ProductService> {
    public ProductController(ProductService service) {
        super(service);
    }

    @GetMapping("/search")
    public ResponseEntity<SuccessResponse> search(@RequestParam String name) {
        return ControllerUtil.returnSuccess(service.findByName(name), HttpStatus.OK);
    }
}
