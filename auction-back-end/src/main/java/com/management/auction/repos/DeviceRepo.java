package com.management.auction.repos;

import com.management.auction.models.UserDevice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DeviceRepo extends JpaRepository<UserDevice, Long> {
    Optional<UserDevice> findByDeviceToken(String token);
}
