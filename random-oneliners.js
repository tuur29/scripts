
// Unwatch all repos from an organization (run on https://github.com/watching)
Array.from(document.querySelectorAll('.Box-row'))
    .filter((e) => e.innerText.indexOf('ORGNAME') > -1)
    .forEach(e => e.querySelector('button[value=included]').click());
