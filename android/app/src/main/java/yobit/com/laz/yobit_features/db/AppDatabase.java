package yobit.com.laz.yobit_features.db;

import androidx.room.Database;
import androidx.room.RoomDatabase;


@Database(entities = {Trades.class, UserTrades.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {
    public abstract TradesDao tradesDao();

    public abstract UserTradesDao userTradesDao();
}