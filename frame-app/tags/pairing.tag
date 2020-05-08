<pairing>

  <div>
    <p>Pairing code</p>
    <h1>{ state.deviceID }</h1>
    <button onclick="{ goToPictureFrame }">Load picture frame</button>
  </div>

  <script>
    export default {
      async onMounted() {
        const deviceID = await db.config.where('key').equals('deviceID').toArray();
        this.update({ deviceID: deviceID[0].value });
      },

      async goToPictureFrame() {
        route.router.push('#/picture-frame');
      },
    }
  </script>

  <style scoped>
    :host {
      position: fixed;
      left: 0;
      top: 0;
      bottom: 0;
      right: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
    }

    h1 {
      font-size: xx-large;
      margin: 50px 20px;
    }

    button {
      color: black;
      font-weight: bold;
      background: gray;
      padding: 20px 30px;
      border-radius: 5px;
    }
  </style>

</pairing>
