package com.example.phone;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

  private WebView frameWebView;

  private ValueCallback<Uri> mUploadMessage;
  public ValueCallback<Uri[]> uploadMessage;
  public static final int REQUEST_SELECT_FILE = 100;
  private final static int FILECHOOSER_RESULTCODE = 1;

  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
        // https://www.apkmirror.com/apk/google-inc/android-system-webview/android-system-webview-83-0-4103-60-release/android-system-webview-83-0-4103-60-2-android-apk-download/download/
        // enables remote debugging of webview with devtools
        // open chrome and chrome://inspect/#devices and inspect webview
        WebView.setWebContentsDebuggingEnabled(true);

      }

        setContentView(R.layout.activity_main);

      // loads spa into web view
      loadSPAIntoWebView();
    }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent intent)
  {
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
    {
      if (requestCode == REQUEST_SELECT_FILE)
      {
        if (uploadMessage == null)
          return;
        uploadMessage.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, intent));
        uploadMessage = null;
      }
    }
    else if (requestCode == FILECHOOSER_RESULTCODE)
    {
      if (null == mUploadMessage)
        return;
      // Use MainActivity.RESULT_OK if you're implementing WebView inside Fragment
      // Use RESULT_OK only if you're implementing WebView inside an Activity
      Uri result = intent == null || resultCode != MainActivity.RESULT_OK ? null : intent.getData();
      mUploadMessage.onReceiveValue(result);
      mUploadMessage = null;
    }
    else
      Toast.makeText(MainActivity.this.getApplicationContext(), "Failed to Upload Image", Toast.LENGTH_LONG).show();
  }

  private void loadSPAIntoWebView () {

    frameWebView = new WebView(this);
    frameWebView.loadUrl("https://st.u-centrix.com:5678/apps/remote/#/");

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




    // something something web view picture & camera
    frameWebViewSettings.setAllowFileAccess(true);
    frameWebViewSettings.setAllowFileAccess(true);
    frameWebViewSettings.setAllowContentAccess(true);

    frameWebView.setWebChromeClient(new WebChromeClient()
    {
      // For 3.0+ Devices (Start)
      // onActivityResult attached before constructor
      protected void openFileChooser(ValueCallback uploadMsg, String acceptType)
      {
        mUploadMessage = uploadMsg;
        Intent i = new Intent(Intent.ACTION_GET_CONTENT);
        i.addCategory(Intent.CATEGORY_OPENABLE);
        i.setType("image/*");
        startActivityForResult(Intent.createChooser(i, "File Browser"), FILECHOOSER_RESULTCODE);
      }


      // For Lollipop 5.0+ Devices
      public boolean onShowFileChooser(WebView mWebView, ValueCallback<Uri[]> filePathCallback, WebChromeClient.FileChooserParams fileChooserParams)
      {
        if (uploadMessage != null) {
          uploadMessage.onReceiveValue(null);
          uploadMessage = null;
        }

        uploadMessage = filePathCallback;

        Intent intent = fileChooserParams.createIntent();
        try
        {
          startActivityForResult(intent, REQUEST_SELECT_FILE);
        } catch (ActivityNotFoundException e)
        {
          uploadMessage = null;
          Toast.makeText(MainActivity.this.getApplicationContext(), "Cannot Open File Chooser", Toast.LENGTH_LONG).show();
          return false;
        }
        return true;
      }

      //For Android 4.1 only
      protected void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture)
      {
        mUploadMessage = uploadMsg;
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("image/*");
        startActivityForResult(Intent.createChooser(intent, "File Browser"), FILECHOOSER_RESULTCODE);
      }

      protected void openFileChooser(ValueCallback<Uri> uploadMsg)
      {
        mUploadMessage = uploadMsg;
        Intent i = new Intent(Intent.ACTION_GET_CONTENT);
        i.addCategory(Intent.CATEGORY_OPENABLE);
        i.setType("image/*");
        startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_RESULTCODE);
      }
    });



    setContentView(frameWebView);
  }
}
