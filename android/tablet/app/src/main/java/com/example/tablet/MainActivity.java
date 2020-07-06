package com.example.tablet;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends AppCompatActivity {

  private WebView frameWebView;

  private int currentApiVersion;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // keep screen on
    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    currentApiVersion = android.os.Build.VERSION.SDK_INT;


    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      // https://www.apkmirror.com/apk/google-inc/android-system-webview/android-system-webview-83-0-4103-60-release/android-system-webview-83-0-4103-60-2-android-apk-download/download/
      // enables remote debugging of webview with devtools
      // open chrome and chrome://inspect/#devices and inspect webview
      WebView.setWebContentsDebuggingEnabled(true);

      // hack around to hide the ui
      hideSystemUI();

    }


    // hides title bar
    getSupportActionBar().hide();

    // hides navigation
    getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);

    setContentView(R.layout.activity_main);

    // loads spa into web view
    loadSPAIntoWebView();
  }

  @Override
  public void onWindowFocusChanged(boolean hasFocus) {
    super.onWindowFocusChanged(hasFocus);
    if (hasFocus) {
      hideSystemUI();
    }
  }

  @Override
  public void onResume(){
    super.onResume();
    hideSystemUI();

  }

  private void hideSystemUI() {
    View decorView = getWindow().getDecorView();
    decorView.setSystemUiVisibility(
      View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
        | View.SYSTEM_UI_FLAG_FULLSCREEN);
  }

//  private void showSystemUI() {
//    View decorView = getWindow().getDecorView();
//    decorView.setSystemUiVisibility(
//      View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
//  }

  private void loadSPAIntoWebView () {

    frameWebView = new WebView(this);
    //frameWebView.loadUrl("https://html5test.com/");
    //frameWebView.loadUrl("https://pictureframe.ngrok.io");
    frameWebView.loadUrl("https://st.u-centrix.com:5678/apps/frame/#/");

    // dirty fix so webview doesn't open Chrome on refresh
    frameWebView.setWebViewClient(new WebViewClient());

    // accepts permissions for video
    frameWebView.setWebChromeClient(new WebChromeClient() {
      @Override
      public void onPermissionRequest(final PermissionRequest request) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
          request.grant(request.getResources());
        }
      }
    });

    WebSettings frameWebViewSettings = frameWebView.getSettings();
    frameWebViewSettings.setJavaScriptEnabled(true);
    frameWebViewSettings.setDomStorageEnabled(true);
    frameWebViewSettings.setSaveFormData(true);
    frameWebViewSettings.setSupportZoom(false);
    frameWebViewSettings.setCacheMode(WebSettings.LOAD_NO_CACHE);
    frameWebViewSettings.setPluginState(WebSettings.PluginState.ON);
    frameWebViewSettings.setUseWideViewPort(true);
    frameWebViewSettings.setLoadWithOverviewMode(true);
    frameWebViewSettings.setMediaPlaybackRequiresUserGesture(false);

    setContentView(frameWebView);
  }

  public void openSettings(android.view.View view) {
    Intent dialogIntent = new Intent(android.provider.Settings.ACTION_SETTINGS);
    final Intent intent = dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    startActivity(dialogIntent);
  }

}
