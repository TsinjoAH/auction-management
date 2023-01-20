package com.management.auction.repos;

import com.management.auction.models.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.ListPagingAndSortingRepository;

import java.util.List;

public interface ProductRepo extends JpaRepository<Product,Long>, ListPagingAndSortingRepository<Product,Long> {
    List<Product> findByNameIsLikeIgnoreCase(String name);

    @Override
    Page<Product> findAll(Pageable pageable);
}
