/*
 * aet-extensions: lighthouse
 *
 * Copyright (C) 2019 Maciej Laskowski
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

'use strict';

const express = require('express');
const bodyParser = require('body-parser');

const spawn = require('child_process').spawn;
const fs = require('fs');

const WORK_DIR = `reports`;

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

function runLighthouse(body, res, next, order) {
  const url = body.url;
  //ToDo rest of the params
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

/*
 * Server initialization
 */
const app = express();
app.use(bodyParser.json());

app.post('/api/v1/inspect', (req, res, next) => {
  console.log(`processing ${req.query.url}`);
runLighthouse(req.body, res, next);
});

const PORT = 5000;

app.listen(PORT, () => {
  console.log(`server running on port ${PORT}`)
});
