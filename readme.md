# Picture frame prototype

1. [Local development](#local-development)
2. [Android](#android)
3. [Resources](#resources)

## Local development

Requires Node.JS 10.x or greater.

```sh
# install dependencies
cd signaling server && npm install && sudo npm i -G http-server

# starts stack
make dev
```

- Signaling server (http://localhost:3000)
- Picture Frame interface for tablet (http://localhost:3001)
- Remote app for phone (http://localhost:3002)

## Android

1. Download latest [WebView](https://www.apkmirror.com/apk/google-inc/android-system-webview/android-system-webview-83-0-4103-60-release/android-system-webview-83-0-4103-60-2-android-apk-download/download/) and install APK on Tablet.
2. Install tablet.apk on tablet and when you run it first then select tablet as default launcher.


## Resources

- https://www.tutorialspoint.com/webrtc/index.htm
- https://blog.bitsrc.io/use-webrtc-and-peerjs-to-build-an-image-sharing-app-f8163b6a6266
- https://morioh.com/p/eda8d6fc06bf
