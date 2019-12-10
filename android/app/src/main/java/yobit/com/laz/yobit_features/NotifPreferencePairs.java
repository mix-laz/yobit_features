package yobit.com.laz.yobit_features;


import android.util.Log;

public class NotifPreferencePairs {
    // @JsonProperty("price")
    private String price = "";
    private String pair = "";

    //===============current timestamp================//
    //@JsonProperty("timestamp")
    private long timestamp;

    // more = true mark, less false mark
    private boolean compare;

    public String getPrice() {
        return price;
    }

    public String getPair() {
        return pair;
    }

    public boolean isCompare() {
        return compare;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public NotifPreferencePairs(String pair, String price, boolean compare, long timestamp) {
        this.pair = pair;
        this.price = price;
        this.compare = compare;
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "NotifPreferencePairs{" +
                "price='" + price + '\'' +
                ", pair='" + pair + '\'' +
                ", timestamp=" + timestamp +
                ", compare=" + compare +
                '}';
    }
}



