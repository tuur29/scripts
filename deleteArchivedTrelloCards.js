#!/home/tuur/.nvm/versions/node/v12.13.1/bin/node

// Delete Archived Trello Cards

// Install node and `node-fetch` globally
// Edit the path to your node executable above

// CONFIG

const globalNodeModulePath = "/home/tuur/.nvm/versions/node/v12.13.1/lib/node_modules/";

const apikey = "KEY"; // Login at: https://trello.com/app-key
const apitoken = "TOKEN"; // Follow link to generate manual token at above link
const boardid = "ID"; // https://trello.com/b/{BOARDID}/{BOARDNAME}

const baseurl = "https://api.trello.com/1";


// CODE

const fetch = require(globalNodeModulePath+'node-fetch');
const request = (url, params) => fetch(`${baseurl}/${url}?key=${apikey}&token=${apitoken}`, params || {}).then(res => res.json());

console.log("Content-type: text/plain\n");

request(`boards/${boardid}/cards/closed`).then(cards => {
  cards.forEach(card => {
    if (Date.now() - new Date(card.dateLastActivity) >= 14 * 24 * 60 * 60 * 1000 && card.id) {
      request(`cards/${card.id}`, { method: 'DELETE' }).then(() => {
        console.log("DELETED: " + card.name);
      });
    }
  });
});
