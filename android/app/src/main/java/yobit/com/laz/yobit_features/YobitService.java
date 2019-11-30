package yobit.com.laz.yobit_features;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.util.Log;


//import com.google.gson.Gson;

import java.util.Map;

import androidx.annotation.NonNull;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class YobitService extends Service {
    public static final String PAIR = "pair";
    public static final String PRICE = "price";

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        Log.d("YobitService", "onStartCommand1: ");

        Log.d("YobitService", "pair: " + intent.getBundleExtra(MainActivity.service_extra).getString("pair"));


        if (intent.getExtras() != null) {
            storePreferencePairs(
                    intent.getBundleExtra(MainActivity.service_extra).getString("pair"),
                    intent.getBundleExtra(MainActivity.service_extra).getString("price"),
                    intent.getBundleExtra(MainActivity.service_extra).getBoolean("compare")
            );
            final Map<String, String> preferencePairsMap = getPreferencePairsPriceMap();
            StringBuilder id = new StringBuilder();
            for (Map.Entry<String, String> entry : preferencePairsMap.entrySet()) {
                id.append(entry.getKey())
                        .append("-");
            }
            //remove last "-" symbol
            if (id.length() > 0)
                id = id.delete(id.length() - 2, id.length() - 1);

            NetworkService.getInstance()
                    .getJSONApi()
                    .getTickerWithPairs(id.toString())
                    .enqueue(new Callback<Map<String, Ticker>>() {
                        @Override
                        public void onResponse(@NonNull Call<Map<String, Ticker>> call, @NonNull Response<Map<String, Ticker>> response) {
                            Map<String, Ticker> body = response.body();
                            if (body != null) {
                                sendBroadcast(body);
                            }
                        }

                        @Override
                        public void onFailure(@NonNull Call<Map<String, Ticker>> call, @NonNull Throwable t) {
                            t.printStackTrace();
                        }
                    });

        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public void sendBroadcast(Map<String, Ticker> body) {
        Map<String, String> sp=getPreferencePairsPriceMap();

        for(Map.Entry<String, Ticker> entry:body.entrySet()){
            if(Float.parseFloat(sp.get(entry.getKey()))==Float.parseFloat(body.get(entry.getKey()).getLast())){


            }

        }
        Intent intent = new Intent(MainActivity.BROADCAST_ACTION);
        intent.putExtra("last",body.get("edc_btc").getLast());
    }




    public void storePreferencePairs(String pair, String price,boolean compare) {
        SharedPreferences mSharedPairsPricePreferences = this.getSharedPreferences(MainActivity.PAIRS_PRICE__PREFERENCES, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = mSharedPairsPricePreferences.edit();
        editor.putString(pair, price);
        editor.apply();

//        NotifPreferencePairs npp= new NotifPreferencePairs();
//        ObjectMapper mapper = new ObjectMapper();
//        NotifPreferencePairs npp = mapper.readValue(null, NotifPreferencePairs.class);

//read from a string
     //   String personJsonStr = "{\"firstname\":\"John\",\"lastname\":\"Doe\"}";
      //  person2 = mapper.readValue(personJsonStr, Person.class);

    }

    public Map<String, String> getPreferencePairsPriceMap() {
        SharedPreferences mSharedPairsPricePreferences = this.getSharedPreferences(MainActivity.PAIRS_PRICE__PREFERENCES, Context.MODE_PRIVATE);
        return (Map<String, String>) mSharedPairsPricePreferences.getAll();

    }

}
