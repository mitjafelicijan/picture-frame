(async (window, document) => {

  // setting up database middleware
  window.db = new Dexie('picture-frame');
  db.version(2).stores({
    pictures: '++id, filename, blob, date',
    config: '++id, key, value',
  });

  // riotjs stuff
  await riot.compile();
  riot.register('route', route.Route);
  riot.register('router', route.Router);
  riot.mount('app');

})(window, document);
