const http = require('http');

const PORT = process.env.PORT || 3000;
const ENV  = process.env.APP_ENV || 'development';

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', env: ENV }));
    return;
  }

  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`Hello from cicd-demo! Running in: ${ENV}\n`);
});

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT} | env=${ENV}`);
});
