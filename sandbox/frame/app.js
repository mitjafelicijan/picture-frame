const deviceID = 'somedeviceid';

const db = new Dexie('picture-frame');
db.version(1).stores({
  pictures: '++id, filename, blob, date',
  config: '++id, key, value',
});

const mainPicture = document.querySelector('.main img');
const pictureTrack = document.querySelector('.picture-track');

const ringtoneSound = document.querySelector('.ringtone');
const messageSound = document.querySelector('.message');

const peer = new Peer(deviceID, {
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

peer.on('connection', async (conn) => {
  conn.on('data', async (data) => {
    if (data.filetype.includes('image')) {
      mainPicture.src = data.blob;

      await db.pictures.add({
        filename: data.filename,
        blob: data.blob,
        date: new Date(),
      });

      messageSound.play();

      renderPictureTrack();
    }
  });
});

peer.on('call', function(call) {
  console.log('recieving call');

  ringtoneSound.play()
  // Answer the call, providing our mediaStream
  //call.answer(mediaStream);
});

const renderPictureTrack = async () => {
  pictureTrack.innerText = '';

  const pictures = await db.pictures.toArray();
  pictures.forEach((picture) => {
    const img = document.createElement('img')
    img.src = picture.blob;
    img.addEventListener('click', async (evt) => {
      mainPicture.src = evt.target.src;
    });

    pictureTrack.prepend(img);
  });
}

const renderFirstImageInMainViewer = async () => {
  let latestImage = await db.pictures.orderBy('id').reverse().limit(1).toArray();
  if (latestImage.length > 0) {
    mainPicture.src = latestImage[0].blob;
  }
}

// render track and first image in main viewer
renderPictureTrack();
renderFirstImageInMainViewer();
