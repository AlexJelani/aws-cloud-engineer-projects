const assert = require("assert");
const { requestHandler } = require("./server");

let statusCode;
let responseBody;

const response = {
  writeHead(code) {
    statusCode = code;
  },
  end(body) {
    responseBody = JSON.parse(body);
  }
};

requestHandler({ url: "/health" }, response);

assert.strictEqual(statusCode, 200);
assert.strictEqual(responseBody.status, "healthy");
console.log("Health endpoint test passed");
