package yobit.com.laz.yobit_features;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;


import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import yobit.com.laz.yobit_features.db.AppDatabase;
import yobit.com.laz.yobit_features.db.Trades;
import yobit.com.laz.yobit_features.db.TradesDao;
import yobit.com.laz.yobit_features.db.UserTradesDao;


public class YobitForegroundService extends Service {
    private static final String TAG = "YobitForegroundService";
    private static Timer timer;
    private static TimerTask timerTask;
    public static final String NOTIFICATION_PRICE_PAIR_CHANNEL_ID = "notif_price_pair";
    public static final String FOREGROUND_CHANNEL_ID = "ForegroundServiceChannel";

    AppDatabase db;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate() called");
        db = YobitApplication.getInstance().getDatabase();
        //sendBroadcast(new Intent(MainActivity.STOP_SERVICE_BROADCAST_ACTION));
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (timer != null) timer.cancel();
        Log.d(TAG, "onDestroy() called");
        // sendBroadcast(new Intent(MainActivity.STOP_SERVICE_BROADCAST_ACTION));
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        startTimer(startId);
        createNotificationChannel();
        Notification notification = new NotificationCompat.Builder(this, FOREGROUND_CHANNEL_ID)
                .setContentTitle("Yobit features")
                .setContentText("")
                .setSmallIcon(R.mipmap.ic_launcher)
                .build();
        startForeground(1, notification);

        return START_REDELIVER_INTENT;
    }


    private void perfomTask(int startId) {
        Log.d(TAG, "onStartCommand called: startId= " + startId);
        final String pairs = getPairs();
        List<String> nick_list = db.nickDao().getList();
        if ((pairs == null || pairs.length() < 1)&&(nick_list.size()==0)) {
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
                            new checkNickAsyncTask().execute();
                        }
                    }

                    @Override
                    public void onFailure(@NonNull Call<Map<String, ArrayList<History>>> call, @NonNull Throwable t) {
                        t.printStackTrace();
                    }
                });
    }

    private void checkNickPresent() {
        List<String> db_nick_list = db.nickDao().getList();
        Document doc = null;
        try {
            doc = Jsoup.connect("https://yobit.net/ru").get();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (doc != null) {
            Elements elements = doc.select("a.nick");
            for(Element element:elements){
                String web_nick = element.text();
                for(String db_nick:db_nick_list){
                    if(db_nick.equals(web_nick)){
                        sendBroadcast(new Intent().putExtra("nick",db_nick).setAction(MainActivity.NICK_PRESENT_BROADCAST_ACTION));
                        db.nickDao().deleteNick(db_nick);
                    }
                }
            }
        }
//        for(String nick:coincidental_nicks){
//            sendBroadcast(new Intent().putExtra("nick",nick).setAction(MainActivity.NICK_PRESENT_BROADCAST_ACTION));
//        }
     //   Log.d(TAG, "element.text() = " + element.text());
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

            final Iterator<History> it_history = value.iterator();
            while (it_history.hasNext()) {
                final History history_next = it_history.next();
                Trades trades = new Trades();
                trades.setPair(pair);
                trades.setType(history_next.getType());
                trades.setPrice(history_next.getPrice());
                trades.setAmount(history_next.getAmount());
                trades.setTimestamp(history_next.getTimestamp());
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
        timer.schedule(timerTask, 1000, 3000); //
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


        final Iterator<PriceNotification> it_pn = priceLessNotification.iterator();
        while (it_pn.hasNext()) {
            PriceNotification pn_next = it_pn.next();

            Intent intent = new Intent(MainActivity.PAIRS_PRICE_BROADCAST_ACTION);
            intent.putExtra("pair_price", pn_next.getPair()+" "+pn_next.getPrice());
            sendBroadcast(intent);
            userTradesDao.deleteNotifiedPair(pn_next.getTimestamp());

            Log.d(TAG, "PriceNotification next =  " + pn_next.toString());
        }

        Log.d(TAG, "USERTRADES AFTER DELETE ALL PAIRS =  " + userTradesDao.getAll().toString());
        clearTradesTable();

        // db.nickDao().getList();
    }

    public class checkNickAsyncTask extends AsyncTask {

        @Override
        protected Object doInBackground(Object[] objects) {
            checkNickPresent();
            return null;
        }

        @Override
        protected void onPostExecute(Object o) {
            super.onPostExecute(o);
        }
    }
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    FOREGROUND_CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    private String getPairs() {
        final UserTradesDao userTradesDao = db.userTradesDao();
        final String pairs = userTradesDao.pairsAsString();
        Log.d(TAG, "arrPairs  : " + pairs);
        return pairs;
    }


}
