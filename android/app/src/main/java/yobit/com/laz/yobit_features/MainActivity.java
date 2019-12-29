package yobit.com.laz.yobit_features;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;

import java.util.List;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import yobit.com.laz.yobit_features.db.AppDatabase;
import yobit.com.laz.yobit_features.db.Nick;
import yobit.com.laz.yobit_features.db.Trades;
import yobit.com.laz.yobit_features.db.UserTrades;
import yobit.com.laz.yobit_features.db.UserTradesDao;


public class MainActivity extends FlutterActivity {
    private Intent forYobitService;
    private YobitReceiver yobitReceiver;
    public final static String PAIRS_PRICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.pairsprice";
    public final static String START_SERVICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.startservice";
    public final static String STOP_SERVICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.stopservice";
    public final static String NICK_PRESENT_BROADCAST_ACTION = "yobit.com.laz.yobit_features.np";
    public static final String SERVICE_EXTRA = "service_extra";
    public static final String ARGUMENTS_PAIR = "pair";
    public static final String ARGUMENTS_PRICE = "price";
    public static final String ARGUMENTS_COMPARE = "compare";
    public static final String ARGUMENTS_TIMESTAMP = "timestamp";
    public static final String NOTIFICATION_PRICE_PAIR_CHANNEL_ID = "notif_price_pair";
    public static final String PAIRS_PRICE__PREFERENCE = "pp_preference";
    private IntentFilter intFiltPP;
    private IntentFilter intFiltStartService;
    private IntentFilter intFiltStopService;
    private static final String TAG = "MainActivity";
    public static AppDatabase db = YobitApplication.getInstance().getDatabase();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        createNotificationChannel();
        forYobitService = new Intent(MainActivity.this, YobitService.class);


//        intFiltPP = new IntentFilter(PAIRS_PRICE_BROADCAST_ACTION);
//        intFiltStopService = new IntentFilter(STOP_SERVICE_BROADCAST_ACTION);
//        intFiltStartService = new IntentFilter(START_SERVICE_BROADCAST_ACTION);
//        registerReceiver(yobitReceiver, intFiltPP);
//        registerReceiver(yobitReceiver, intFiltStartService);
//        registerReceiver(yobitReceiver, intFiltStopService);
//        //unregisterReceiver(yobitReceiver);


        new MethodChannel(getFlutterView(), "com.yobit_features.messages").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("startService")) {

                    storeUserTrades(
                            methodCall.argument(ARGUMENTS_PAIR),
                            methodCall.argument(ARGUMENTS_PRICE),
                            Integer.parseInt(methodCall.argument(ARGUMENTS_COMPARE)),
                            TimeUnit.MILLISECONDS.toSeconds(Long.parseLong(methodCall.argument(ARGUMENTS_TIMESTAMP)))
                    );
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(forYobitService);
                    }else  startService(forYobitService);


                    List<String> allAsString = db.userTradesDao().getAllAsString();
                    result.success(allAsString);

                } else if (methodCall.method.equals("stopService")) {
                    stopService(forYobitService);
                }else if (methodCall.method.equals("removeUserConditionPrice")) {
                    db.userTradesDao().deleteNotifiedPair(Long.parseLong(methodCall.argument("timestamp")));
                    List<String> allAsString = db.userTradesDao().getAllAsString();
                    result.success(allAsString);
                    Log.d(TAG, "onDestroy called");

                }else if (methodCall.method.equals("getUserConditionsPrice")) {
                    List<String> allAsString = db.userTradesDao().getAllAsString();
                    result.success(allAsString);
                }else if (methodCall.method.equals("getNickList")) {
                    List<String> list = db.nickDao().getList();
                    result.success(list);
                }else if (methodCall.method.equals("trackingNick")) {
                    Nick nick =new Nick(methodCall.argument("nick"));
                    db.nickDao().insert(nick);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(forYobitService);
                    }else  startService(forYobitService);
                    List<String> list = db.nickDao().getList();
                    result.success(list);
                }else if (methodCall.method.equals("removeNick")) {
                    db.nickDao().deleteNick(methodCall.argument("name"));
                    List<String> list = db.nickDao().getList();
                    result.success(list);
                }

            }
        });
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();

    }

    public void storeUserTrades(String pair, String price, int compare, long timestamp) {

        UserTradesDao usertradesDao = db.userTradesDao();
        UserTrades usertrades = new UserTrades();
        usertrades.setPair(pair);
        usertrades.setPrice(price);
        usertrades.setCompare(compare);
        usertrades.setTimestamp(timestamp);
        usertradesDao.insert(usertrades);

        Log.d(TAG, "UserTrades: " + usertrades.toString());
    }

    private String objTojson(String pair, String price, boolean compare, long timestamp) {
        String jsonStr = "";

        NotifPreferencePairs npp = new NotifPreferencePairs(pair, price, compare, timestamp);

        Gson gson = new Gson();

        jsonStr = gson.toJson(npp);

        return jsonStr;
    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.price_channel);
            int importance = NotificationManager.IMPORTANCE_MAX;
            NotificationChannel channel = new NotificationChannel("price_channel_id", name, importance);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    public void startService(String pair,String price,boolean compare,Intent intent) {
    /*if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
      startForegroundService(forYobitService);
    } else {
      startService(forYobitService);
    }*/
        Bundle b = new Bundle();
        b.putString(ARGUMENTS_PAIR, pair);
        b.putString(ARGUMENTS_PRICE, price);
        b.putBoolean(ARGUMENTS_COMPARE, compare);
        forYobitService.putExtra(SERVICE_EXTRA, b);
        startService(forYobitService);
    }

}
