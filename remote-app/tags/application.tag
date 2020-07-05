<app>

  <router>
    <route path="/apps/remote/#/"></route>
    <route path="/apps/remote/#/pairing">
      <pairing></pairing>
    </route>
    <route path="/apps/remote/#/control">
      <control></control>
    </route>
  </router>

  <script>
    export default {
      async onMounted() {
        window.remoteDeviceID = null;
        if (await db.config.where('key').equals('remoteDeviceID').count() === 0) {
          route.router.push(`${pathPrefix}#/pairing`);
        } else {
          const existingDeviceID = await db.config.where('key').equals('remoteDeviceID').toArray();
          window.remoteDeviceID = existingDeviceID[0].value;
          route.router.push(`${pathPrefix}#/control`);
        }




        /*let deviceID = null;

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
          route.router.push(`${pathPrefix}#/picture-frame`);
        }

        route.router.push(`${pathPrefix}#/pairing`);

        console.log('===========', deviceID)

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
              console.log('==>', data)

              await db.pictures.add({
                filename: data.filename,
                blob: data.blob,
                date: new Date(),
              });

              route.router.push(`${pathPrefix}#/picture-frame`);
            }
          });
        });*/
      },

    }
  </script>

</app>
