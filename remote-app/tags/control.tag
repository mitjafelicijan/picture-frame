<control>

  <div>
    <h1>Control</h1>

    <div>
      <label for="photo">Select and send image</label>
      <input type="file" id="photo" accept="image/*">
    </div>

  </div>

  <script>
    const blobToBase64 = (blob) => {
      const reader = new FileReader();
      reader.readAsDataURL(blob);
      return new Promise(resolve => {
        reader.onloadend = () => {
          resolve(reader.result);
        };
      });
    };

    const processImage = (file, maxWidth, maxHeight) => {
      return new Promise((resolve, reject) => {
        let image = new Image();
        image.src = URL.createObjectURL(file);
        image.onload = () => {
          let width = image.width;
          let height = image.height;
          
          console.log('width', width);
          console.log('height', height);

          if (width <= maxWidth && height <= maxHeight) {
            resolve(file);
          }

          let newWidth;
          let newHeight;

          if (width > height) {
            newHeight = Math.round(height * (maxWidth / width));
            newWidth = maxWidth;
          } else {
            newWidth = Math.round(width * (maxHeight / height));
            newHeight = maxHeight;
          }
          
          console.log('newWidth', newWidth);
          console.log('newHeight', newHeight);
          
          let canvas = document.createElement('canvas');
          
          if (newWidth > newHeight) {
          	console.log('should rotate');
          	
            canvas.width = newHeight;
            canvas.height = newWidth;
            
            let context = canvas.getContext('2d');
            
            // translate to center-canvas 
            // the origin [0,0] is now center-canvas
            context.translate(canvas.width / 2, canvas.height / 2);
            
            // roate the canvas by +90% (==Math.PI/2)
            context.rotate(Math.PI / 2);
            
            // draw the signature
            // since images draw from top-left offset the draw by 1/2 width & height
            context.drawImage(image, -newWidth / 2, -newHeight / 2, newWidth, newHeight);
            
            // un-rotate the canvas by -90% (== -Math.PI/2)
            context.rotate(-Math.PI / 2);

            // un-translate the canvas back to origin==top-left canvas
            context.translate(-canvas.width / 2, -canvas.height / 2);
            
          } else {
            console.log('no rotation reuired');
            
            canvas.width = newWidth;
            canvas.height = newHeight;
            
            let context = canvas.getContext('2d');
            
            context.drawImage(image, 0, 0, newWidth, newHeight);
          }
          
          canvas.toBlob(resolve, file.type);
        };
        image.onerror = reject;
      });
    }


    export default {
      async onMounted() {
        const peer = new Peer({
          host: window.location.hostname,
          port: window.location.port,
          path: '/rtc/',
          secure: (window.location.hostname !== 'localhost') || false, // require ssl only if not localhost
        })
          .on('open', (peerID) => {
            console.log('remote', 'peerID:', peerID);
          })
          .on('error', (error) => {
            console.error(error);
          });

        document.querySelector('input').onchange = async (event) => {
          const conn = peer.connect(window.remoteDeviceID, {
            serialization: 'json',
            reliable: true,
          });

          conn.on('open', async () => {
            try {
              const file = event.target.files[0];
              processImage(file, 600, 960).then(async (blob) => {
                const payload = {
                  blob: await blobToBase64(blob),
                  filename: file.name,
                  filetype: file.type
                };

                conn.send(payload);
              }, err => {
                console.error('photo error', err);
              });
            } catch (error) {
              console.log(error);
            }
          });

          conn.on('close', () => {
            console.log('connection closed')
          });
        }

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

</control>
