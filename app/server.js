const http = require("http");

const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || "1.0.0";

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { "Content-Type": "application/json" });
  res.end(JSON.stringify(payload));
}

function requestHandler(req, res) {
  if (req.url === "/health") {
    sendJson(res, 200, { status: "healthy", version });
    return;
  }

  if (req.url === "/") {
    sendJson(res, 200, {
    service: "aws-cloud-engineer-portfolio-app",
    status: "ok",
    version,
    message: "Served from an Auto Scaling group behind an Application Load Balancer."
  });
    return;
  }

  sendJson(res, 404, { error: "not_found" });
}

const app = http.createServer(requestHandler);

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Portfolio app listening on port ${port}`);
  });
}

module.exports = { app, requestHandler };
