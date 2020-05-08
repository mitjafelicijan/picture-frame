<app>

  <router>
    <route path="#/">
      <pairing></pairing>
    </route>

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
        // generates new device id if non exist
        if (await db.config.where('key').equals('deviceID').count() === 0) {
          const deviceIDGeneratorResponse = await fetch('http://localhost:3000/generate-device-id');
          const generatedDeviceID = await deviceIDGeneratorResponse.text();

          await db.config.add({
            key: 'deviceID',
            value: generatedDeviceID,
          });

          //route.router.push('#/pairing');
        } else {
          //route.router.push('#/picture-frame');
        }

        route.router.push('#/pairing');

      },

    }
  </script>

</app>
