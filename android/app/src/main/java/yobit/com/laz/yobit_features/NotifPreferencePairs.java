package yobit.com.laz.yobit_features;


import android.util.Log;

public class NotifPreferencePairs {
    //=============== more = true================//
   // @JsonProperty("price_more")
    private String price_more = "";

    //===============less = false================//
    //@JsonProperty("price_less")
    private String price_less = "";

    //===============current timestamp================//
    //@JsonProperty("timestamp")
    private long timestamp;

    // @JsonProperty("price_more")
    public String getPricemore() {
        return price_more;
    }

    //@JsonProperty("price_more")
    public void setPricemore(String price_more) {
        this.price_more = price_more;
    }


   // @JsonProperty("price_less")
    public String getPriceless() {
        return price_less;
    }

    //@JsonProperty("price_less")
    public void setPriceless(String price_less) {
        this.price_less = price_less;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public NotifPreferencePairs(String price, boolean compare, long timestamp) {
        Log.d("NotifPreferencePairs", "compare= "+compare);

        if (compare)
            this.price_more = price;
        else
            this.price_less = price;


        this.timestamp=timestamp;
    }

    @Override
    public String toString() {
        return "NotifPreferencePairs{" +
                "price_more='" + price_more + '\'' +
                ", price_less='" + price_less + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }
}



