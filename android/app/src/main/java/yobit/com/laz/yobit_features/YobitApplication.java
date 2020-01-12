package yobit.com.laz.yobit_features;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import androidx.room.Room;
import io.flutter.app.FlutterApplication;
import yobit.com.laz.yobit_features.db.AppDatabase;

public class YobitApplication extends FlutterApplication {

    public static YobitApplication instance;

    private AppDatabase database;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        database = Room.databaseBuilder(this, AppDatabase.class, "database")
                .allowMainThreadQueries()
                .fallbackToDestructiveMigration()
                .build();

         if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel("messages","Messages", NotificationManager.IMPORTANCE_LOW);
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }
    }


    public static YobitApplication getInstance() {
        return instance;
    }

    public AppDatabase getDatabase() {
        return database;
    }
}