package com.management.auction.repos;

import com.management.auction.models.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductRepo extends JpaRepository<Product,Long> {
    List<Product> findByNameIsLikeIgnoreCase(String name);
}
