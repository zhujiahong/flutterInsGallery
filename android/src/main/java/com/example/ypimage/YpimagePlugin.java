package com.example.ypimage;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.LifecycleOwner;

import com.bumptech.glide.manager.Lifecycle;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.engine.ImageEngine;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.instagram.InsGallery;
import com.luck.picture.lib.listener.OnAlbumItemClickListener;
import com.luck.picture.lib.listener.OnResultCallbackListener;
import com.luck.picture.lib.permissions.PermissionChecker;
import com.luck.picture.lib.tools.PictureFileUtils;
import com.luck.pictureselector.GlideCacheEngine;
import com.luck.pictureselector.GlideEngine;
import com.luck.pictureselector.adapter.GridImageAdapter;

import org.jetbrains.annotations.NotNull;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
//import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;




/** YpimagePlugin */
public class YpimagePlugin implements FlutterPlugin, MethodCallHandler ,ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity


  private MethodChannel channel;
  private GridImageAdapter mAdapter ;

  private final static String TAG = PluginRegistry.Registrar .class.getSimpleName();
  private   Activity activity;
  private   Context context;

  @Nullable private Lifecycle lifecycle;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ypimage");
    channel.setMethodCallHandler(this);

//此处不能添加其他代码 否则onAttachedToActivity方法不走 activity获取不到

  }




  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d(TAG, "onMethodCall:" + this.activity);
    Toast.makeText(this.activity, "TestActivity", Toast.LENGTH_SHORT).show();
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }if (call.method.equals("presentInsImage")) {

          if (PermissionChecker.checkSelfPermission(context, Manifest.permission.CAMERA) &&PermissionChecker.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE)&&PermissionChecker.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

            Log.d("打印","ss");

            mAdapter = new GridImageAdapter(context, new GridImageAdapter.onAddPicClickListener() {
              @Override
              public void onAddPicClick() {

              }
            });
            InsGallery.openGallery(this.activity, GlideEngine.createGlideEngine(), GlideCacheEngine.createCacheEngine(), new OnResultCallbackListenerImpl(mAdapter));

          } else {
      PermissionChecker.requestPermissions(activity, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.CAMERA,Manifest.permission.WRITE_EXTERNAL_STORAGE,},
              PictureConfig.APPLY_STORAGE_PERMISSIONS_CODE);
    }


//      InsGallery.openGallery(Activity, GlideEngine.createGlideEngine(), new OnResultCallbackListenerImpl(mAdapter));



//if (activity != null) {
//        InsGallery.openGallery(activity, GlideEngine.createGlideEngine(),new OnResultCallbackListenerImpl(mAdapter));
//}






    }  else {
      result.notImplemented();
    }
  }


  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
//    Log.d(TAG, "onAttachedToActivity");
    this.activity = binding.getActivity();
    this.context = activity;
    Log.d(TAG, "onAttachedToActivity:" + this.activity);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onDetachedFromEngine(@NonNull @NotNull FlutterPluginBinding binding) {

  }

  private static class OnResultCallbackListenerImpl implements OnResultCallbackListener<LocalMedia> {
    private WeakReference<com.luck.pictureselector.adapter.GridImageAdapter> mAdapter;

    public OnResultCallbackListenerImpl(com.luck.pictureselector.adapter.GridImageAdapter adapter) {
      mAdapter = new WeakReference<>(adapter);
    }

    @Override
    public void onResult(List<LocalMedia> result) {
      for (LocalMedia media : result) {
        Log.i(TAG, "是否压缩:" + media.isCompressed());
        Log.i(TAG, "压缩:" + media.getCompressPath());
        Log.i(TAG, "原图:" + media.getPath());
        Log.i(TAG, "是否裁剪:" + media.isCut());
        Log.i(TAG, "裁剪:" + media.getCutPath());
        Log.i(TAG, "是否开启原图:" + media.isOriginal());
        Log.i(TAG, "原图路径:" + media.getOriginalPath());
        Log.i(TAG, "Android Q 特有Path:" + media.getAndroidQToPath());
        Log.i(TAG, "Size: " + media.getSize());
      }
      com.luck.pictureselector.adapter.GridImageAdapter adapter = mAdapter.get();
      if (adapter != null) {
        adapter.setList(result);
        adapter.notify();
      }
    }

    @Override
    public void onCancel() {
      Log.i(TAG, "PictureSelector Cancel");
    }
  }


}






