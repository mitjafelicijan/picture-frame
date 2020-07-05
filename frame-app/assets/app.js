(async (window, document) => {

  // setting up database middleware
  window.db = new Dexie('picture-frame-frame');
  db.version(2).stores({
    pictures: '++id, filename, blob, date',
    config: '++id, key, value',
  });

  // get or generate device id
  window.deviceID = null;
  // generates new device id if non exist
  if (await db.config.where('key').equals('deviceID').count() === 0) {
    const deviceIDGeneratorResponse = await fetch(`${window.location.protocol}//${signalingServerHost}:${signalingServerPort}/generate-device-id`);
    const generatedDeviceID = await deviceIDGeneratorResponse.text();

    await db.config.add({
      key: 'deviceID',
      value: generatedDeviceID,
    });

    window.deviceID = generatedDeviceID;
  } else {
    const existingDeviceID = await db.config.where('key').equals('deviceID').toArray();
    window.deviceID = existingDeviceID[0].value;
  }

  // peerjs connection
  window.peer = new Peer(window.deviceID, {
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

  // riotjs stuff
  await riot.compile();
  riot.register('route', route.Route);
  riot.register('router', route.Router);
  riot.mount('app');

})(window, document);
