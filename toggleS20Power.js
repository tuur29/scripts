#!/usr/local/bin/node

// Sonoff S20 wifi power outlet hack without hardware modifications

// Install node and the 'ws' package
// Edit the path to your node executable above
// You can get the other 4 settings by snooping traffic from the app

// More info: 
// - snoop ssl traffic: https://mitmproxy.org/
// - based on: https://github.com/gbro115/homebridge-ewelink

// Usage: ./toggleS20Power.js on/off

// CONFIG (fake data)

const globalNodeModulePath = "/opt/nodejs/lib/node_modules/";

const url = "wss://eu-pconnect2.coolkit.cc:8080/api/ws";
const bearertoken = "pymb06auh2uj5zctezy5ll0z4pzazn81uz549ook";
const apikey = "pymb06au-ll0z-lkms-1786-v3pqe9w70uty";
const deviceid = "187717a724";


// CODE

console.log("Content-type: text/plain\n");

var action = "off";
if (process.argv[2] == "on") action = "on";

const WebSocket = require(globalNodeModulePath+'ws');
const ws = new WebSocket(url);
 
ws.on('open', function open() {
    // login
    ws.send('{"action": "userOnline","userAgent": "app","at": "' + bearertoken + '","apikey": "' + apikey +'"}');
});

var firstdata = true;
ws.on('message', function incoming(data) {
  console.log(data);
  if (firstdata) {
    // send command
    ws.send('{"action": "update","userAgent": "app","apikey": "' + apikey + '","deviceid": "' + deviceid + '","params": {"switch": "' + action + '"}}');
    setTimeout(function timeout() {
      ws.terminate();
    }, 250);
  }
  firstdata = false;
});