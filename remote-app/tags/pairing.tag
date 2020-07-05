<pairing>

  <div>
    <h1>Pairing</h1>

    <div id="reader"></div>
    <label for="qr-input-file">Scan QR code from frame app</label>
    <input type="file" id="qr-input-file" accept="image/*" capture>
  </div>

  <script>
    export default {
      async onMounted() {
        const html5QrCode = new Html5Qrcode('reader');
        const fileinput = document.getElementById('qr-input-file');

        fileinput.addEventListener('change', e => {
          if (e.target.files.length == 0) {
            return;
          }

          const imageFile = e.target.files[0];
          html5QrCode.scanFile(imageFile, /* showImage= */true)
            .then(qrCodeMessage => {

              db.config.add({
                key: 'remoteDeviceID',
                value: qrCodeMessage,
              });

              window.remoteDeviceID = qrCodeMessage;
              alert(qrCodeMessage);
              route.router.push(`${pathPrefix}#/control`);
            })
            .catch(err => {
              alert(`Error scanning file. Reason: ${err}`)
            });
        });

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
      font-size: x-large;
      margin-bottom: 30px;
    }

    input[type=file] {
      display: none;
    }

    label {
      cursor: pointer;
      background: blue;
      color: white;
      padding: 40px 20px;
      display: block;
      text-align: center;
      font-weight: bold;
    }
  </style>

</pairing>
