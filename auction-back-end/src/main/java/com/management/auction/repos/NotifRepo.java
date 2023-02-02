package com.management.auction.repos;

import com.management.auction.models.Notif;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

@Component
public interface NotifRepo extends MongoRepository<Notif, Long> {
}
