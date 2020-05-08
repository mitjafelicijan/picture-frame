<app>

  <router>
    <route path="/apps/frame/#/">
      <pairing></pairing>
    </route>

    <route path="/apps/frame/#/pairing">
      <pairing></pairing>
    </route>
    <route path="/apps/frame/#/picture-frame">
      <pictureFrame></pictureFrame>
    </route>
  </router>

  <script>
    export default {
      async onMounted() {
        //

        // generates new device id if non exist
        if (await db.config.where('key').equals('deviceID').count() === 0) {
          const deviceIDGeneratorResponse = await fetch('/generate-device-id');
          const generatedDeviceID = await deviceIDGeneratorResponse.text();

          await db.config.add({
            key: 'deviceID',
            value: generatedDeviceID,
          });

          route.router.push('/apps/frame/#/pairing');
        } else {
          route.router.push('/apps/frame/#/picture-frame');
        }

      },

    }
  </script>

</app>
