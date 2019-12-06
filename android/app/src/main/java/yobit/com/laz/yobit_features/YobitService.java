package yobit.com.laz.yobit_features;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;



import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;

import java.util.ArrayList;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import androidx.annotation.NonNull;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class YobitService extends Service {
    private static final String TAG = "YobitService";
    private static Timer timer;
    private static TimerTask timerTask;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate() called");

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy() called");
        sendBroadcast( new Intent(MainActivity.STOP_SERVICE_BROADCAST_ACTION));

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        startTimer(startId);
        return START_REDELIVER_INTENT;
    }



    private void perfomTask(int startId) {
        Log.d(TAG, "onStartCommand called: startId= " + startId);
        final String pairs = getPairs();

        if((pairs!=null)&&(pairs.length()<1)){
            if(timer!=null) timer.cancel();
            stopSelf();
        }

        NetworkService.getInstance()
                .getJSONApi()
                .getHistoryWithPairs(pairs)
                .enqueue(new Callback<Map<String, ArrayList<History>>>() {
                    @Override
                    public void onResponse(@NonNull Call<Map<String, ArrayList<History>>> call, @NonNull Response<Map<String, ArrayList<History>>> response) {
                        Map<String, ArrayList<History>> body = response.body();
                        if (body != null) {
                            sendBroadcast(body);
                        }
                    }

                    @Override
                    public void onFailure(@NonNull Call<Map<String, ArrayList<History>>> call, @NonNull Throwable t) {
                        t.printStackTrace();
                    }
                });
    }

    public void startTimer(int startId) {
        //set a new Timer - if one is already running, cancel it to avoid two running at the same time
        stoptimertask();
        timer = new Timer();


        //initialize the TimerTask's job
        initializeTimerTask(startId);

        //schedule the timer, to wake up every 5 second
        timer.schedule(timerTask, 1000, 5000); //
    }

    public void stoptimertask() {
        //stop the timer, if it's not already null
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    public void initializeTimerTask(int startId) {
        Log.i(TAG, "initialising TimerTask");
        timerTask = new TimerTask() {
            public void run() {
                perfomTask(startId);
            }
        };
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public void sendBroadcast(Map<String, ArrayList<History>> body) {

        Map<String, String> prefMap = getPreferencePairsPriceMap();


        Log.d(TAG, "current getPreferencePairsPriceMap = " + prefMap.toString());
        Log.d(TAG, "prefMap.keySet().size() = " + prefMap.keySet().size());




        for (Map.Entry<String, String> stringEntry : prefMap.entrySet()) {


            final NotifPreferencePairs notifPreferencePairs = jsonToObject(prefMap.get(stringEntry.getKey()));

            ArrayList<History> historyArrayList = body.get(stringEntry.getKey());

            boolean br = false;
            for (History history : historyArrayList) {
                Log.d(TAG, "history.getTimestamp() > notifPreferencePairs.getTimestamp(): " + (history.getTimestamp() > notifPreferencePairs.getTimestamp()));
                Log.d(TAG, "history.getTimestamp() : " + history.getTimestamp());
                Log.d(TAG, "notifPreferencePairs.getTimestamp() : " + notifPreferencePairs.getTimestamp());


                if (!TextUtils.isEmpty(notifPreferencePairs.getPricemore())) {
                    if (Double.parseDouble(history.getPrice()) > Double.parseDouble(notifPreferencePairs.getPricemore()) &&
                            history.getTimestamp() > notifPreferencePairs.getTimestamp()) {
                        Intent intent = new Intent(MainActivity.PAIRS_PRICE_BROADCAST_ACTION);
                        intent.putExtra("price", history.getPrice());
                        intent.putExtra("pair_name", stringEntry.getKey());
                        sendBroadcast(intent);
                        removePairPreference(stringEntry.getKey());
                        br = true;
                    }
                }
                if (!TextUtils.isEmpty(notifPreferencePairs.getPriceless())) {
                    if (Double.parseDouble(history.getPrice()) < Double.parseDouble(notifPreferencePairs.getPriceless()) &&
                            history.getTimestamp() > notifPreferencePairs.getTimestamp()) {
                        Intent intent = new Intent(MainActivity.PAIRS_PRICE_BROADCAST_ACTION);
                        intent.putExtra("price", history.getPrice());
                        intent.putExtra("pair_name", stringEntry.getKey());
                        sendBroadcast(intent);
                        removePairPreference(stringEntry.getKey());
                        br = true;
                    }
                }
                if (br) break;
            }

        }

    }
    private String getPairs() {
        final Map<String, String> preferencePairsMap = getPreferencePairsPriceMap();
        StringBuilder arrPairs = new StringBuilder();
        for (Map.Entry<String, String> entry : preferencePairsMap.entrySet()) {
            Log.d(TAG, "next pair: " + entry.getKey());

            arrPairs.append((String) entry.getKey()).append("-");
        }

        //remove last "-" symbol
        if (arrPairs.length() > 0)
            arrPairs = arrPairs.delete(arrPairs.length() - 1, arrPairs.length());
        return arrPairs.toString();
    }


    public Map<String, String> getPreferencePairsPriceMap() {
        SharedPreferences mSharedPairsPricePreferences = this.getSharedPreferences(MainActivity.PAIRS_PRICE__PREFERENCES, Context.MODE_PRIVATE);
        return (Map<String, String>) mSharedPairsPricePreferences.getAll();

    }

    public void removePairPreference(String key) {
        SharedPreferences mSharedPairsPricePreferences = this.getSharedPreferences(MainActivity.PAIRS_PRICE__PREFERENCES, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = mSharedPairsPricePreferences.edit();
        editor.remove(key);
        editor.apply();
//        Log.d(TAG, "After remove " + mSharedPairsPricePreferences.getString(key,"Empty"));


    }


    private NotifPreferencePairs jsonToObject(String prefJson) {
        // final ObjectMapper mapper = new ObjectMapper();
        NotifPreferencePairs notifPreferencePairs = null;

        Gson gson = new Gson();
        try {
            notifPreferencePairs = gson.fromJson(prefJson, NotifPreferencePairs.class);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
        }


//        try {
//            notifPreferencePairs = mapper.readValue(prefJson, NotifPreferencePairs.class);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
        return notifPreferencePairs;
    }

}
