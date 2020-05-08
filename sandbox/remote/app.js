const remoteDeviceID = 'somedeviceid';

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

const blobToBase64 = (blob) => {
  const reader = new FileReader();
  reader.readAsDataURL(blob);
  return new Promise(resolve => {
    reader.onloadend = () => {
      resolve(reader.result);
    };
  });
};

const resizeImage = (file, maxWidth, maxHeight) => {
  return new Promise((resolve, reject) => {
    let image = new Image();
    image.src = URL.createObjectURL(file);
    image.onload = () => {
      let width = image.width;
      let height = image.height;

      if (width <= maxWidth && height <= maxHeight) {
        resolve(file);
      }

      let newWidth;
      let newHeight;

      if (width > height) {
        newHeight = height * (maxWidth / width);
        newWidth = maxWidth;
      } else {
        newWidth = width * (maxHeight / height);
        newHeight = maxHeight;
      }

      let canvas = document.createElement('canvas');
      canvas.width = newWidth;
      canvas.height = newHeight;

      let context = canvas.getContext('2d');
      context.drawImage(image, 0, 0, newWidth, newHeight);
      canvas.toBlob(resolve, file.type);
    };
    image.onerror = reject;
  });
}

document.querySelector('input').onchange = async (event) => {
  const conn = peer.connect(remoteDeviceID, {
    serialization: 'json',
    reliable: true,
  });

  conn.on('open', async () => {
    try {
      const file = event.target.files[0];
      resizeImage(file, 960, 600).then(async(blob) => {
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


document.querySelector('.call').addEventListener('click', (evt) => {
  const conn = peer.connect(remoteDeviceID, {
    serialization: 'json',
    reliable: true,
  });

  conn.on('open', async () => {
    console.log('trying to call');

    navigator.getUserMedia({ video: true, audio: false }, function (mediaStream) {
      var call = peer.call(remoteDeviceID, mediaStream);
    }, (error) => {
      console.log(error);
    });


  });

  /* */
});
