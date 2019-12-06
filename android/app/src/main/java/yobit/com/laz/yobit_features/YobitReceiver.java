package yobit.com.laz.yobit_features;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.os.Build;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import androidx.annotation.*;
import androidx.core.app.NotificationManagerCompat;


public class YobitReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("YobitReceiver", "onReceive called");
        if(intent.getAction().equals(MainActivity.START_SERVICE_BROADCAST_ACTION))
            sendNotifFromService(context,new Intent().putExtra("text","Service statrted"));
        if(intent.getAction().equals(MainActivity.STOP_SERVICE_BROADCAST_ACTION))
            sendNotifFromService(context,new Intent().putExtra("text","Service destroyed"));

        if (intent.getExtras() != null) {
            if(intent.getAction().equals(MainActivity.PAIRS_PRICE_BROADCAST_ACTION))
                sendNotif(intent,context);

//            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//
//            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"messages")
//                    .setContentText("This is running in Background")
//                    .setContentTitle("Flutter Background");
//                    //.setSmallIcon(R.drawable.ic_android_black_24dp);
//            startForeground(101,builder.build());
//        }




        }

    }
    public void sendNotif( Intent intent,Context context) {
      //  Log.d("last", intent.getStringExtra("last")+"");

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, MainActivity.NOTIFICATION_PRICE_PAIR_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Reached the price")
                .setContentText(new StringBuilder()
                        .append(intent.getStringExtra("pair_name"))
                        .append(" ")
                        .append(intent.getStringExtra("price")).toString())
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                // Set the intent that will fire when the user taps the notification
                .setContentIntent(null)
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                .setAutoCancel(true);
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(1, builder.build());
    }
    public void sendNotifFromService( Context context,Intent intent) {
        //  Log.d("last", intent.getStringExtra("last")+"");

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, MainActivity.NOTIFICATION_PRICE_PAIR_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(intent.getStringExtra("text"))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                // Set the intent that will fire when the user taps the notification
                .setContentIntent(null)
                .setAutoCancel(true);
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(2, builder.build());
    }
}
