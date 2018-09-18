#!/usr/local/bin/node

// Pause music on a locally running 'Google Play Music Desktop Player' instance (for api v1.1)

// Install node and both 'ws' and 'readline' packages somewhere
// Edit the path to your node executable below
// run the script without parameters for getting an api token


// CONFIG

const globalNodeModulePath = "/opt/nodejs/lib/node_modules/";

const url = "ws://localhost:5672"; // this should always stay the same
const appname = "Pause script"; // there is no reason to edit this
const token = ""; // fill this in once you run the script for the first time or use it as the fist parameter



// CODE

const WebSocket = require(globalNodeModulePath+'ws');
const readline = require('readline');

const ws = new WebSocket(url);
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

let key = process.argv[2] || token;

if (key) {

    ws.on('open', function open() {
        // authenticate
        ws.send('{"namespace": "connect","method": "connect","arguments": ["'+appname+'","'+key+'"]}');
        // send pause command
        ws.send('{"namespace": "playback","method": "playPause"}');
        setTimeout(() => {
            ws.close();
            process.exit();
        }, 100);
    });

} else {

    ws.on('open', function open() {
        // request code
        ws.send('{"namespace": "connect","method": "connect", "arguments": ["'+appname+'"]}');

        // ask for code
        rl.question('Please enter temporary four digit code: ', (code) => {
            // request permanent code
            ws.send('{"namespace": "connect","method": "connect","arguments": ["'+appname+'","'+code+'"]}');
            rl.close();
        });
    });

    // listen for api key
    ws.on('message', function incoming(data) {
      if (data.indexOf('"channel":"connect"') > -1) {
          let json = JSON.parse(data);
          if (json.payload != "CODE_REQUIRED") {

              console.log("\nYour API key is: "+ json.payload);
              console.log("\n In the future you can either call this script like this: `./pauseGPMDP.js "+json.payload+"`");
              console.log(" or simply fill the 'token' variable at the start of this script.");
              ws.close();
              process.exit();

          }
      }
    });

}
