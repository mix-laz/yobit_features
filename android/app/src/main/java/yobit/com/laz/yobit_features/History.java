package yobit.com.laz.yobit_features;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class History {

    // "type":"ask",
    //"amount":0.101,
    //"tid":41234426,
    @SerializedName("price")
    @Expose
    String price;

    @SerializedName("timestamp")
    @Expose
    int timestamp;


    @SerializedName("type")
    @Expose
    String type;


    @SerializedName("amount")
    @Expose
    double amount;


    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public int getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(int timestamp) {
        this.timestamp = timestamp;
    }

    public String getType() {
        return type;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public void setType(String type) {
        this.type = type;
    }
}
