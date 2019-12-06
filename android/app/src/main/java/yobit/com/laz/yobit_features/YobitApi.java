package yobit.com.laz.yobit_features;
import java.util.ArrayList;
import java.util.Map;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface YobitApi {
    @GET("ticker/{pairs}")
    public Call<Map<String,Ticker>> getTickerWithPairs(@Path("pairs") String pairs);
    @GET("trades/{pairs}?limit=150")
    public Call<Map<String, ArrayList<History>>> getHistoryWithPairs(@Path("pairs") String pairs);
}
