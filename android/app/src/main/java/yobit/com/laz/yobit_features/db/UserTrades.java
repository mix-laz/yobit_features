package yobit.com.laz.yobit_features.db;

import java.util.Date;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class UserTrades {

    @PrimaryKey(autoGenerate = true)
    private long id;

    private String pair;
    private int compare;
    private String price;
    private long timestamp;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getPair() {
        return pair;
    }

    public void setPair(String pair) {
        this.pair = pair;
    }

    public int getCompare() {
        return compare;
    }

    public void setCompare(int compare) {
        this.compare = compare;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "UserTrades{" +
                "id=" + id +
                ", pair='" + pair + '\'' +
                ", compare=" + compare +
                ", price='" + price + '\'' +
                ", timestamp=" + new Date(timestamp).toString() +
                '}';
    }
}
