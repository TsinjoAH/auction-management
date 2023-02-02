package com.management.auction.services;

import com.management.auction.models.UserDevice;
import com.management.auction.repos.DeviceRepo;
import custom.springutils.exception.CustomException;
import custom.springutils.service.CrudService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class DeviceService extends CrudService<UserDevice, DeviceRepo> {

    public DeviceService(DeviceRepo repo) {
        super(repo);
    }

    public UserDevice register (UserDevice userDevice) throws CustomException {
        System.out.println("Device registration: "+userDevice.getDeviceToken());
        Optional<UserDevice> found = this.repo.findByDeviceToken(userDevice.getDeviceToken());
        if (found.isPresent()) return found.get();
        return create(userDevice);
    }

}
