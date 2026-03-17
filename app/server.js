const http = require('http');

const PORT = process.env.PORT || 3000;
const INSTANCE_ID = process.env.INSTANCE_ID || 'unknown-instance';

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({
    message: "Whale in the Cloud",
    instance: INSTANCE_ID
  }));
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});