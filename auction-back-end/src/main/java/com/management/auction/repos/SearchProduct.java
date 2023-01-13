package com.management.auction.repos;

import com.management.auction.models.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SearchProduct extends JpaRepository<Product, String> {
    List<Product> findByName (String Name);
}
