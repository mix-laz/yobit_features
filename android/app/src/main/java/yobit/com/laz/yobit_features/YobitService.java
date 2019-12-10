package yobit.com.laz.yobit_features;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.util.Log;


import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import androidx.annotation.NonNull;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import yobit.com.laz.yobit_features.db.AppDatabase;
import yobit.com.laz.yobit_features.db.Trades;
import yobit.com.laz.yobit_features.db.TradesDao;
import yobit.com.laz.yobit_features.db.UserTradesDao;


public class YobitService extends Service {
    private static final String TAG = "YobitService";
    private static Timer timer;
    private static TimerTask timerTask;
    AppDatabase db;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate() called");
        db = YobitApplication.getInstance().getDatabase();

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy() called");
        sendBroadcast(new Intent(MainActivity.STOP_SERVICE_BROADCAST_ACTION));

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
        if (pairs == null || pairs.length() < 1) {
            if (timer != null) timer.cancel();
            stopSelf();
            return;
        }


        NetworkService.getInstance()
                .getJSONApi()
                .getHistoryWithPairs(pairs)
                .enqueue(new Callback<Map<String, ArrayList<History>>>() {
                    @Override
                    public void onResponse(@NonNull Call<Map<String, ArrayList<History>>> call, @NonNull Response<Map<String, ArrayList<History>>> response) {
                        Map<String, ArrayList<History>> body = response.body();
                        if (body != null) {
                            writeToTradesTable(body);
                            sendBroadcastIfAny();
                            clearTradesTable();

                        }
                    }
                    @Override
                    public void onFailure(@NonNull Call<Map<String, ArrayList<History>>> call, @NonNull Throwable t) {
                        t.printStackTrace();
                    }
                });
    }

    private void clearTradesTable() {
        TradesDao tradesDao = db.tradesDao();
        tradesDao.clearTable();
    }

    private void writeToTradesTable(Map<String, ArrayList<History>> body) {

        TradesDao tradesDao = db.tradesDao();

        for (Map.Entry<String, ArrayList<History>> entry : body.entrySet()) {
            final ArrayList<History> value = entry.getValue();
            String pair = entry.getKey();

            final Iterator<History> iterator = value.iterator();
            while (iterator.hasNext()) {
                final History next = iterator.next();
                Trades trades = new Trades();
                trades.setPair(pair);
                trades.setType(next.getType());
                ;
                trades.setPrice(next.getPrice());
                trades.setAmount(next.getAmount());
                trades.setTimestamp(next.getTimestamp());
                tradesDao.insert(trades);
            }

            final List<Trades> all = tradesDao.getAll();
            Log.d(TAG, "List<Trades> size = " + all.size());

            final Iterator<Trades> it = all.iterator();
            while (it.hasNext()) {
                final Trades next = it.next();
                Log.d(TAG, "Next row from Trades table: " + next.toString());


            }
        }


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

    public void sendBroadcastIfAny() {

        UserTradesDao userTradesDao = db.userTradesDao();
        List<PriceNotification> priceLessNotification = userTradesDao.getPriceLessNotification();
        List<PriceNotification> priceMoreNotification = userTradesDao.getPriceMoreNotification();
        priceLessNotification.addAll(priceMoreNotification);

        Log.d(TAG, "priceLessNotification size =  " + priceLessNotification.size());
        Log.d(TAG, "priceMoreNotification size =  " + priceMoreNotification.size());


        final Iterator<PriceNotification> iteratorM = priceLessNotification.iterator();
        PriceNotification pn = null;
        while (iteratorM.hasNext()) {
            pn = iteratorM.next();

            Intent intent = new Intent(MainActivity.PAIRS_PRICE_BROADCAST_ACTION);
            intent.putExtra("price", pn.getPrice());
            intent.putExtra("pair_name", pn.getPair());
            sendBroadcast(intent);
            userTradesDao.deleteNotifiedPair(pn.getTimestamp());

            Log.d(TAG, "PriceNotification next =  " + pn.toString());
        }

        Log.d(TAG, "USERTRADES AFTER DELETE ALL PAIRS =  " + userTradesDao.getAll().toString());

    }


    private String getPairs() {
        final UserTradesDao userTradesDao = db.userTradesDao();
        final String pairs = userTradesDao.pairsAsString();
        Log.d(TAG, "arrPairs  : " + pairs);
        return pairs;
    }





}
