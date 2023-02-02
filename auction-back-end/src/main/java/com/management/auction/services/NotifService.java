package com.management.auction.services;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.management.auction.models.UserDevice;
import com.management.auction.models.auction.Auction;
import com.management.auction.models.notification.Notif;
import com.management.auction.repos.DeviceRepo;
import com.management.auction.repos.NotifRepo;
import com.management.auction.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class NotifService {

    private String baseUrl = "https://auction-management-production-a966.up.railway.app/";

    @Autowired
    protected NotifRepo repo;

    @Autowired
    protected DeviceRepo deviceRepo;

    protected FirebaseMessaging firebaseMessaging;

    @Autowired
    protected ThreadPoolTaskScheduler scheduler;

    public NotifService(FirebaseMessaging firebaseMessaging) {
        this.firebaseMessaging = firebaseMessaging;
    }

    public List<Notif> findNotifications(Long user){
        return repo.findByUserAndDateBeforeOrderByDateDesc(user, new Date());
    }


    public Notif save(Notif notif){
        return repo.save(notif);
    }

    public void testPurpose () throws FirebaseMessagingException {
        Notif notif = this.repo.findById("63dbe748e88c677e5844b0ac").get();
        notif.setDate(new Date(System.currentTimeMillis() + 5000));
        sendNotification(notif);
    }

    public void scheduleForAuction (Auction auction) {
        Notif notif = buildNotif(auction);
        save(notif);
        scheduleNotification(notif);
    }

    private Notif buildNotif(Auction auction) {
        Notif notif = new Notif();
        notif.setTitle("Enchere terminée");
        notif.setContent("L'enchere " + auction.getTitle() + " est terminée, Clickez pour plus de details et voir les resultats");
        notif.setLink("/auctions/" + auction.getId());
        notif.setUser(auction.getUser().getId());
        notif.setImage(baseUrl + auction.getImages().get(0).getPicPath());
        notif.setDate(auction.getEndDate());
        return notif;
    }

    public void scheduleNotification(Notif notif) {
        scheduler.schedule(() -> {
            try {
                sendNotification(notif);
                System.out.println("Notification sent at " + notif.getDate() + " to " + notif.getUser());
            } catch (FirebaseMessagingException e) {
                e.printStackTrace();
            }
        }, notif.getDate());
    }

    public void sendNotification(Notif notif) throws FirebaseMessagingException {

        List<String> devices = deviceRepo.findByUserId(notif.getUser());
        if (devices.isEmpty()) return;

        Notification notification = Notification
                .builder()
                .setTitle(notif.getTitle())
                .setBody(notif.getContent())
                .setImage(notif.getImage())
                .build();

        Map<String, String> data = buildData(notif);

        firebaseMessaging.sendAll(buildMessages(notification, devices, data));
    }

    private List<Message> buildMessages (Notification notification, List<String> devices, Map<String, String> data) {
        List<Message> messages = new ArrayList<>();
        for (String device : devices) {
            messages.add(
                Message
                    .builder()
                    .setToken(device)
                    .putAllData(data)
                    .setNotification(notification)
                    .build()
            );
        }
        return messages;
    }

    public Map<String, String> buildData(Notif notif) {
        Map<String, String> data = new HashMap<>();
        data.put("title", notif.getTitle());
        data.put("content", notif.getContent());
        data.put("image", notif.getImage());
        data.put("link", notif.getLink());
        data.put("date", notif.getDate().toString());
        data.put("user", notif.getUser().toString());
        return data;
    }

}
