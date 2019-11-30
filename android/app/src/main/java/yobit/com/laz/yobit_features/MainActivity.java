package yobit.com.laz.yobit_features;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

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
    public final static String BROADCAST_ACTION = "yobit.com.laz.yobit_features.broadcast";
    public static final String service_extra = "SERVICE_EXTRA";
    public static final String NOTIFICATION_PRICE_PAIR_CHANNEL_ID = "notif_price_pair";
    public static final String PAIRS_PRICE__PREFERENCES = "pp_preferences";
    public static final String APP_PREFERENCES_PAIRS_PRICE = "pairs_price_preferences";
    private IntentFilter intFilt;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        forYobitService = new Intent(MainActivity.this, YobitService.class);
        yobitReceiver = new YobitReceiver();

        intFilt = new IntentFilter(BROADCAST_ACTION);
        registerReceiver(yobitReceiver,intFilt);


        new MethodChannel(getFlutterView(), "com.yobit_features.messages").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("startService")) {

                    startService(methodCall.argument("pair"),methodCall.argument("price"),forYobitService);
                    result.success("Service Started");
                }
            }
        });
    }





    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopService(forYobitService);
        unregisterReceiver(yobitReceiver);
    }


    public void startService(String pair,String price,Intent intent) {
    /*if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
      startForegroundService(forYobitService);
    } else {
      startService(forYobitService);
    }*/

        Bundle b = new Bundle();
        b.putString("pair", pair);
        b.putString("price", price);
        forYobitService.putExtra(service_extra, b);
        startService(forYobitService);
    }




}
