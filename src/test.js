const http = require('http');

const options = {
  hostname: 'localhost',
  port: process.env.PORT || 3000,
  path: '/health',
  method: 'GET',
  timeout: 3000
};

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    const body = JSON.parse(data);
    if (res.statusCode === 200 && body.status === 'ok') {
      console.log('✅ Health check passed:', body);
      process.exit(0);
    } else {
      console.error('❌ Health check failed:', body);
      process.exit(1);
    }
  });
});

req.on('error', (e) => {
  console.error('❌ Could not connect to server:', e.message);
  process.exit(1);
});

req.end();
