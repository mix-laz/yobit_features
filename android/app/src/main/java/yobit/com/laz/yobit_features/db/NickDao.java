package yobit.com.laz.yobit_features.db;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao

public interface NickDao {

    @Query("SELECT name FROM nick")
    List<String> getList();


    @Query("DELETE  FROM nick WHERE name=:name")
    void deleteNick(String name);


    @Query("SELECT *  FROM nick WHERE name=:name")
    Nick  nickByName(String name);

    @Insert
    void insert(Nick nick);
}
