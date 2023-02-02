package com.management.auction.repos;

import com.management.auction.models.notification.Notif;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

@Component
public interface NotifRepo extends MongoRepository<Notif, String> {
    List<Notif> findByUserAndDateBeforeOrderByDateDesc(Long user, Date date);
}
