package yobit.com.laz.yobit_features.db;

import java.util.List;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

@Dao
public interface TradesDao {

    @Query("SELECT * FROM trades")
    List<Trades> getAll();

    @Query("SELECT * FROM trades WHERE id = :id")
    Trades getById(long id);

    @Query("DELETE FROM trades")
    void clearTable();


    @Insert
    void insert(Trades trades);

    @Update
    void update(Trades trades);

    @Delete
    void delete(Trades trades);

}
