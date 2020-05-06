const express = require('express');

const app = express();
const port = 3000 || process.env.PORT;

app.use('/interfaces', express.static('interfaces'));

app.get('/', async (req, res) => {
  res.send(':)');
});

app.listen(port, async () => {
  console.log(`Server running at http://localhost:${port}`);
});
