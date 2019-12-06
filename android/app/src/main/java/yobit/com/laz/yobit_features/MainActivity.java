package yobit.com.laz.yobit_features;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;

import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


import androidx.core.app.NotificationCompat;
import androidx.annotation.*;
import androidx.core.app.NotificationManagerCompat;


public class MainActivity extends FlutterActivity {
    private Intent forYobitService;
    private YobitReceiver yobitReceiver;
    public final static String PAIRS_PRICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.pairsprice";
    public final static String START_SERVICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.startservice";
    public final static String STOP_SERVICE_BROADCAST_ACTION = "yobit.com.laz.yobit_features.stopservice";
    public static final String SERVICE_EXTRA = "service_extra";
    public static final String ARGUMENTS_PAIR = "pair";
    public static final String ARGUMENTS_PRICE = "price";
    public static final String ARGUMENTS_COMPARE = "compare";
    public static final String ARGUMENTS_TIMESTAMP = "timestamp";
    public static final String NOTIFICATION_PRICE_PAIR_CHANNEL_ID = "notif_price_pair";
    public static final String PAIRS_PRICE__PREFERENCES = "pp_preferences";
    private IntentFilter intFiltPP;
    private IntentFilter intFiltStartService;
    private IntentFilter intFiltStopService;
    private static final String TAG = "MainActivity";



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
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

                    storePreferencePairs(
                            methodCall.argument(ARGUMENTS_PAIR),
                            methodCall.argument(ARGUMENTS_PRICE),
                            Boolean.parseBoolean(methodCall.argument(ARGUMENTS_COMPARE)),
                            TimeUnit.MILLISECONDS.toSeconds(Long.parseLong(methodCall.argument(ARGUMENTS_TIMESTAMP)))
                    );

                    startService(forYobitService);
                    result.success("Service Started");
                }
            }
        });
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy called");

    }

    public void storePreferencePairs(String pair, String price, boolean compare, long timestamp) {
        SharedPreferences mSharedPairsPricePreferences = this.getSharedPreferences(PAIRS_PRICE__PREFERENCES, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = mSharedPairsPricePreferences.edit();
        String objString = objTojson(price, compare,timestamp);
        editor.putString(pair, objString);
        editor.apply();
    }

    private String objTojson(String price, boolean compare,long timestamp) {
        String jsonStr = "";

        NotifPreferencePairs npp = new NotifPreferencePairs(price, compare,timestamp);

        Gson gson = new Gson();

        jsonStr = gson.toJson(npp);

        return jsonStr;
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
