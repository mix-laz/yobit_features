package yobit.com.laz.yobit_features.db;

import java.util.List;
import java.util.Queue;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;
import yobit.com.laz.yobit_features.PriceNotification;

@Dao
public interface UserTradesDao {
    @Query("SELECT  DISTINCT pair ,timestamp ,price,compare,id FROM usertrades")
    List<UserTrades> getUniquePairAll();

    @Query("SELECT DISTINCT GROUP_CONCAT(pair , '-')  FROM usertrades")
    String pairsAsString();

    @Query("SELECT * FROM usertrades")
    List<UserTrades> getAll();

    @Query("SELECT * FROM usertrades WHERE id = :id")
    UserTrades getById(long id);

    @Query("SELECT pair || ',' || compare || ',' || price || ',' || timestamp FROM usertrades")
    List<String> getAllAsString();

    @Query("SELECT trades.price, trades.pair,  usertrades.timestamp, usertrades.compare, MIN(trades.price) " +
            "FROM trades, usertrades " +
            "WHERE trades.pair == usertrades.pair " +
            "AND trades.timestamp>usertrades.timestamp  " +
            "AND usertrades.compare==0 AND trades.price< usertrades.price GROUP BY trades.pair  ")
    List<PriceNotification> getPriceLessNotification();


    @Query("SELECT trades.price, trades.pair, trades.price, usertrades.timestamp, usertrades.compare, MAX(trades.price) " +
            "FROM trades, usertrades " +
            "WHERE trades.pair == usertrades.pair " +
            "AND trades.timestamp>usertrades.timestamp  " +
            "AND usertrades.compare==1 AND trades.price > usertrades.price  GROUP BY trades.pair")
    List<PriceNotification> getPriceMoreNotification();


    @Query("DELETE FROM  usertrades WHERE timestamp=:timestamp ")
    void deleteNotifiedPair(long timestamp);


    @Insert
    void insert(UserTrades trades);

    @Update
    void update(UserTrades trades);

    @Delete
    void delete(UserTrades trades);
}
