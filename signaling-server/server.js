const path = require('path');
const express = require('express');
const peer = require('peer');
const chalk = require('chalk');
const datastore = require('nedb');
const cors = require('cors');

// database for storing unique device ids
const db = new datastore(path.join(__dirname, 'devices.db'));
db.loadDatabase();

const app = express();
const port = 3000 || process.env.PORT;

const httpServer = app.listen(port, async () => {
  console.log(`Server running at http://localhost:${port}`);
});

const peerServer = peer.ExpressPeerServer(httpServer, {
  debug: true,
  allow_discovery: true,
  path: '/'
});

app.use(cors());
app.use('/rtc', peerServer);

app.use('/apps/frame', express.static('../frame-app'));
app.use('/apps/remote', express.static('../remote-app'));

app.get('/generate-device-id', async (req, res) => {
  db.insert({ header: req.headers }, (error, document) => {
    return res.send(document._id);
  });
});

app.get('/', async (req, res) => {
  res.send(`
  <style>* {font-size: 50px}</style>
    <li><a href="/apps/frame/#/">frame</li>
    <li><a href="/apps/frame/#/pairing">frame paring</li>
    <li><a href="/apps/remote/#/">remote</li>
  `);
});

peerServer.on('connection', (client) => {
  console.log('connection', chalk.green(client.id), 'with token', chalk.green(client.token));
});

peerServer.on('disconnect', (client) => {
  console.log('disconnect', chalk.red(client.id), 'with token', chalk.red(client.token));
});
