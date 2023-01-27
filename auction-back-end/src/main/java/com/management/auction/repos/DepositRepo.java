package com.management.auction.repos;

import com.management.auction.models.Deposit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface DepositRepo extends JpaRepository<Deposit,Long>, PagingAndSortingRepository<Deposit,Long> {
    List<Deposit> findByUserId(Long id);

    List<Deposit> findByStatus(Integer status);
    Page<Deposit> findByUserId(Long id, Pageable pageable);
}
