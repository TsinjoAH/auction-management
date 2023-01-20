package com.management.auction.repos.stat;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface StatRepo {
    List<HashMap<String,Object>> getAuctionPerDayBetween(Date min, Date max);
    List<HashMap<String,Object>> getCommissionPerDayBetween(Date min,Date max);
    HashMap<String,Object> getTotalAndIncrease();
    HashMap<String,Object> getUserTotalAndIncrease();
    HashMap<String,Object> getCommissionTotalAndIncrease();
    List<HashMap<String,Object>> getUserAuctionCount();
    List<HashMap<String,Object>> getUserSalesCount();
    List<HashMap<String,Object>> getProductStat(int page);
    List<HashMap<String,Object>> getCategoryStat(int page);

}
