package com.management.auction.repos;

import com.management.auction.models.UserDevice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface DeviceRepo extends JpaRepository<UserDevice, Long> {
    Optional<UserDevice> findByDeviceTokenAndUserId(String token, Long userId);

    @Query("SELECT deviceToken FROM UserDevice WHERE userId = ?1")
    List<String> findByUserId(Long userId);
}
