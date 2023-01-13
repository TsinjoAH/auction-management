package com.management.auction.services;

import com.management.auction.models.Product;
import com.management.auction.repos.SearchProduct;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class searchProductService{

    protected final SearchProduct search;

    public searchProductService(SearchProduct s){

        this.search=s;

    }

    public List<Product> findByName(String name){
        List<Product> product = this.search.findByName(name);
        return  product;
    }

}
