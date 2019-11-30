package yobit.com.laz.yobit_features;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

class Ticker {
    //  "high":105.41,
    //"low":104.67,
    //"vol":43398.22251455,
    //"vol_cur":4546.26962359,
    //"buy":104.2,
    //"sell":105.11,
    //"updated":1418654531

    @SerializedName("last")
    @Expose
    private String last;
    @SerializedName("avg")
    @Expose
    private String avg;



    public String getLast() {
        return last;
    }

    public void setLast(String last) {
        this.last = last;
    }

    public String getAvg() {
        return avg;
    }

    public void setAvg(String avg) {
        this.avg = avg;
    }
}