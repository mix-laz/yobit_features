package yobit.com.laz.yobit_features;

import java.util.Date;

public class PriceNotification {

    private String pair;

    private String price;
    private int compare;
    private long timestamp;

    public String getPair() {
        return pair;
    }

    public void setPair(String pair) {
        this.pair = pair;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public int getCompare() {
        return compare;
    }

    public void setCompare(int compare) {
        this.compare = compare;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "PriceNotification{" +
                "pair='" + pair + '\'' +
                ", price='" + price + '\'' +
                ", compare=" + compare +
                ", timestamp=" + new Date(timestamp).toString() +
                '}';
    }
}
