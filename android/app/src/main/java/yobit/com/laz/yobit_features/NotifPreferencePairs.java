package yobit.com.laz.yobit_features;

import com.fasterxml.jackson.annotation.JsonProperty;


public class NotifPreferencePairs{

    @JsonProperty("pair")
    private String pair;
    @JsonProperty("pair")
    public String getPair() {
        return pair;
    }
    @JsonProperty("pair")
    public void setPair(String pair) {
        this.pair = pair;
    }

    public NotifPreferencePairs(String pair) {
        this.pair = pair;
    }

    public class Body{
        @JsonProperty("price")
        private String price;
        //more = true,less = false
        @JsonProperty("compare")
        private boolean compare;

        @JsonProperty("price")
        public String getPrice() {
            return price;
        }
        @JsonProperty("price")
        public void setPrice(String price) {
            this.price = price;
        }
        @JsonProperty("compare")
        public boolean isCompare() {
            return compare;
        }
        @JsonProperty("compare")
        public void setCompare(boolean compare) {
            this.compare = compare;
        }

        public Body(String price, boolean compare) {
            this.price = price;
            this.compare = compare;
        }
    }

}