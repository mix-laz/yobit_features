package yobit.com.laz.yobit_features.db;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class Nick {
    @PrimaryKey(autoGenerate = true)
    private int id;

    private String name;

    public Nick(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
