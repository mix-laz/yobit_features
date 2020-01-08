package yobit.com.laz.yobit_features;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.os.Build;

import java.sql.Timestamp;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;


public class YobitReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if(intent.getAction().equals(MainActivity.START_SERVICE_BROADCAST_ACTION))
            sendNotification(context,new Intent()
                    .putExtra("title","Service statrted")
                    .putExtra("text","")
            );
        if(intent.getAction().equals(MainActivity.STOP_SERVICE_BROADCAST_ACTION))
            sendNotification(context,new Intent()
                    .putExtra("title","Service destroyed")
                    .putExtra("text","")
            );
        if(intent.getAction().equals(MainActivity.PAIRS_PRICE_BROADCAST_ACTION))
            sendNotification(context,new Intent()
                    .putExtra("title","Стоимость достигнута")
                    .putExtra("text",intent.getStringExtra("pair_price"))
            );
        if(intent.getAction().equals(MainActivity.NICK_PRESENT_BROADCAST_ACTION))
            sendNotification(context,new Intent()
                    .putExtra("title","Ник в чате")
                    .putExtra("text",intent.getStringExtra("nick"))
            );


//       if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"messages")
//                    .setContentText("This is running in Background")
//                    .setContentTitle("Flutter Background");
//                    //.setSmallIcon(R.drawable.ic_android_black_24dp);
//            startForeground(101,builder.build());
//        }
    }


    public void sendNotification(Context context,Intent intent ) {
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel(
                    YobitForegroundService.NOTIFICATION_PRICE_PAIR_CHANNEL_ID, "price_channel", NotificationManagerCompat.IMPORTANCE_MAX);
            notificationManager.createNotificationChannel(channel);
        }
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, YobitForegroundService.NOTIFICATION_PRICE_PAIR_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(intent.getStringExtra("title"))
                .setContentText(new StringBuilder()
                        .append(intent.getStringExtra("text")).toString())
                .setPriority(NotificationCompat.PRIORITY_MAX)
                // Set the intent that will fire when the user taps the notification
                .setContentIntent(null)
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))

                .setAutoCancel(true);

        notificationManager.notify(new Long(new Timestamp(System.currentTimeMillis()).getTime()).intValue(), builder.build());
    }




}
