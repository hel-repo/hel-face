require('./Css/material.min.css');
require('./Css/main.css');

var Elm = require('./Main.elm');

var root  = document.getElementById('root');

Elm.Main.embed(root);