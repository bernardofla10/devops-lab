const http = require("http");

const TARGET_URL = process.env.TARGET_URL || "http://api-day06:3000/health";

console.log(
  JSON.stringify({
    timestamp: new Date().toISOString(),
    message: "Client started",
    targetUrl: TARGET_URL
  })
);

http
  .get(TARGET_URL, (res) => {
    let data = "";

    res.on("data", (chunk) => {
      data += chunk;
    });

    res.on("end", () => {
      console.log(
        JSON.stringify({
          timestamp: new Date().toISOString(),
          statusCode: res.statusCode,
          response: data
        })
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        process.exit(0);
      }

      process.exit(1);
    });
  })
  .on("error", (err) => {
    console.error(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        error: err.message,
        targetUrl: TARGET_URL
      })
    );

    process.exit(1);
  });