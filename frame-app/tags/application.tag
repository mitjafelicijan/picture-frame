<app>

  <router>
    <route path="#/"></route>
    <route path="#/pairing">
      <pairing></pairing>
    </route>
    <route path="#/picture-frame">
      <pictureFrame></pictureFrame>
    </route>
  </router>

  <script>
    export default {
      async onMounted() {
        let deviceID = null;

        // generates new device id if non exist
        if (await db.config.where('key').equals('deviceID').count() === 0) {
          const deviceIDGeneratorResponse = await fetch(`${window.location.protocol}//${signalingServerHost}:${signalingServerPort}/generate-device-id`);
          const generatedDeviceID = await deviceIDGeneratorResponse.text();

          await db.config.add({
            key: 'deviceID',
            value: generatedDeviceID,
          });

          deviceID = generatedDeviceID;
          route.router.push('#/pairing');
        } else {
          const existingDeviceID = await db.config.where('key').equals('deviceID').toArray();
          deviceID = existingDeviceID[0].value;
          route.router.push('#/picture-frame');
        }

        window.peer = new Peer(deviceID, {
          host: signalingServerHost,
          port: signalingServerPort,
          path: '/rtc/',
          secure: (window.location.hostname !== 'localhost') || false, // require ssl only if not localhost
        });

        window.peer.on('open', (peerID) => {
          console.log('peerID:', peerID);
        });

        window.peer.on('error', (error) => {
          console.error(error);
        });

        window.peer.on('connection', async (conn) => {
          conn.on('data', async (data) => {
            if (data.filetype.includes('image')) {
              console.log(data)


              await db.pictures.add({
                filename: data.filename,
                blob: data.blob,
                date: new Date(),
              });

              route.router.push('#/picture-frame');
            }
          });
        });
      },

    }
  </script>

</app>
