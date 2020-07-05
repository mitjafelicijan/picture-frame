<pairing>

  <div>
    <h3>Pairing code</h3>
    <div id="qrcode"></div>
    <p>
      <!--<button onclick="{ goToPictureFrame }">Open settings</button>-->
      <button onclick="{ goToPictureFrame }">Load picture frame</button>
    </p>
  </div>

  <script>
    export default {
      async onMounted() {
        new QRCode(document.getElementById('qrcode'), window.deviceID);
      },

      async goToPictureFrame() {
        route.router.push(`${pathPrefix}#/picture-frame`);
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

    h3 {
      font-size: x-large;
    }

    button {
      color: white;
      font-weight: bold;
      background: gray;
      padding: 20px 30px;
      border-radius: 5px;
      margin: 0 10px;
    }

    #qrcode {
      border: 20px solid white;
      background: white;
      width: fit-content;
      display: inline-block;
      margin-top: 20px;
      margin-bottom: 20px;
    }
  </style>

</pairing>
