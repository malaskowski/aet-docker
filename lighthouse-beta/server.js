'use strict';

const express = require('express');
const app = express();
const spawn = require('child_process').spawn;
const fs = require('fs');
const WORK_DIR = `/home/chrome/reports`;

function validURL(url, res) {
  if (!url) {
    res.status(400).send('Please provide a URL.');
    return false;
  }

  if (!url.startsWith('http')) {
    res.status(400).send('URL must start with http.');
    return false;
  }

  return true;
}

function cleanUp(fileName) {
  try {
    fs.unlinkSync(`${WORK_DIR}/${fileName}`);
    console.info(`${fileName} removed`);
  } catch (err) {
    console.error(err)
  }
}

function respond(fileName, start, res) {
  try {
    let rawData = fs.readFileSync(`${WORK_DIR}/${fileName}`);
    let reportAsJson = JSON.parse(rawData);
    const duration = Date.now() - start;
    res.status(200).send({
      duration: duration,
      report: reportAsJson
    });
  } catch (err) {
    console.error(err);
    res.status(500).send(`Failed to create response: ${err}`);
  }
}

function callLighthouseAndRespond(args, url, res, start, fileName) {
  return new Promise(resolve => {
    console.log(`Running: lighthouse ${args} ${url}`);
  const child = spawn('lighthouse', [...args, url]);
  child.stderr.pipe(process.stderr);
  child.stdout.pipe(process.stdout);

  child.on('close', statusCode => {
    respond(fileName, start, res);
  cleanUp(fileName);
});
})
}

function runLighthouse(url, res, next, order) {
  const start = Date.now();
  if (!validURL(url, res)) {
    return;
  }
  const format = 'json';
  const fileName = `report.${start}.${format}`;
  const args = [
    `--chrome-flags="--headless`,// --disable-gpu"`,
    `--output-path=${WORK_DIR}/${fileName}`,
    `--output=${format}`,
    `--port=0`
  ];
  callLighthouseAndRespond(args, url, res, start, fileName, order);
}

app.get('/api/v1/inspect', (req, res, next) => {
  console.log(`processing ${req.query.url}`);
runLighthouse(req.query.url, res, next);
});
const PORT = 5000;

app.listen(PORT, () => {
  console.log(`server running on port ${PORT}`)
});
