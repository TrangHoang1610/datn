package com.example.init_app;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

//public class MainActivity extends FlutterActivity implements RatingDialog.RatingDialogInterFace {
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.init_app";
    private static final int SELECT_IMAGE = 9000;
    MethodChannel.Result resultGetImages = null;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == SELECT_IMAGE) {
                if (data != null) {
                    try {
                        Bitmap bitmap = MediaStore.Images.Media.getBitmap(getApplicationContext().getContentResolver(), data.getData());
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 70, outputStream);
                        Log.e("onActivityResult: ", Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT));
                        resultGetImages.success(Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT));
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

            }
        }
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
//                    case "rateManual": {
//                        break;
//                    }
//                    case "rateAuto": {
//                        break;
//                    }
                    case "getImage": {
                        resultGetImages = result;
                        Intent intent = new Intent();
                        intent.setType("image/*");
                        intent.setAction(Intent.ACTION_GET_CONTENT);
                        startActivityForResult(Intent.createChooser(intent, "Select Picture"), SELECT_IMAGE);
                    }
                }
            }
        });

    }

//    public static void rateApp(Context context) {
//        Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
//                Uri.parse("http://play.google.com/store/apps/details?id=" + context.getPackageName())));
//        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
//        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        context.startActivity(intent);
//    }
//
//    //Rate
//    private void rateAuto() {
//        int rate = SharedPrefsUtils.getInstance(this).getInt("rate");
//        if (rate < 1) {
//            RatingDialog ratingDialog = new RatingDialog(this);
//            ratingDialog.setRatingDialogListener(this);
//            ratingDialog.showDialog();
//        }
//    }
//
//    private void rateManual() {
//        RatingDialog ratingDialog = new RatingDialog(this);
//        ratingDialog.setRatingDialogListener(this);
//        ratingDialog.showDialog();
//    }
//
//    @Override
//    public void onDismiss() {
//
//    }
//
//    @Override
//    public void onSubmit(float rating) {
//        if (rating > 3) {
//            rateApp(this);
//            SharedPrefsUtils.getInstance(this).putInt("rate", 5);
//        }
//    }
//
//    @Override
//    public void onRatingChanged(float rating) {
//    }
}
