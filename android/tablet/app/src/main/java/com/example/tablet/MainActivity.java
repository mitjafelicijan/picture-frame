package com.example.tablet;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {

  private WebView frameWebView;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

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

  private void hideSystemUI() {
    View decorView = getWindow().getDecorView();
    decorView.setSystemUiVisibility(
      View.SYSTEM_UI_FLAG_IMMERSIVE
        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
        | View.SYSTEM_UI_FLAG_FULLSCREEN);
  }

  private void showSystemUI() {
    View decorView = getWindow().getDecorView();
    decorView.setSystemUiVisibility(
      View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
  }

  private void loadSPAIntoWebView () {
    frameWebView = new WebView(this);
    frameWebView.loadUrl("https://html5test.com/");

    WebSettings frameWebViewSettings = frameWebView.getSettings();
    frameWebViewSettings.setJavaScriptEnabled(true);

    setContentView(frameWebView);
  }

  public void openSettings(android.view.View view) {
    Intent dialogIntent = new Intent(android.provider.Settings.ACTION_SETTINGS);
    final Intent intent = dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    startActivity(dialogIntent);
  }

}
