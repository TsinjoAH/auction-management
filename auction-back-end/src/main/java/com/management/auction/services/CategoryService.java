package com.management.auction.services;

import com.management.auction.models.Category;
import com.management.auction.repos.CategoryRepo;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

@Service
public class CategoryService extends CrudService<Category, CategoryRepo> {
    public CategoryService(CategoryRepo repo) {
        super(repo);
    }
}
