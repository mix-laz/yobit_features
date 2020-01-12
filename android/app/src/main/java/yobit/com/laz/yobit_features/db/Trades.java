package yobit.com.laz.yobit_features.db;

import java.security.Timestamp;
import java.util.Date;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class Trades {

    @PrimaryKey(autoGenerate = true)
    private long id;

    private String pair;

    private String type;
    private String price;
    private double amount;
    private String tid;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getTid() {
        return tid;
    }

    public void setTid(String tid) {
        this.tid = tid;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "Trades{" +
                "id=" + id +
                ", pair='" + pair + '\'' +
                ", type='" + type + '\'' +
                ", price='" + price + '\'' +
                ", amount='" + amount + '\'' +
                ", tid='" + tid + '\'' +
                ", timestamp=" + new Date(timestamp).toString() +
                '}';
    }
}
