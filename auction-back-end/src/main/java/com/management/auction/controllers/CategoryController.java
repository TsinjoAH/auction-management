package com.management.auction.controllers;

import com.management.auction.models.Category;
import com.management.auction.services.CategoryService;
import custom.springutils.controller.CrudController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories")
public class CategoryController extends CrudController<Category, CategoryService> {
    public CategoryController(CategoryService service) {
        super(service);
    }
}
