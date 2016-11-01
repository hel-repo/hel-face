require('./Css/material.min.css');
require('./Css/main.css');
require('./Css/header.css');
require('./Css/cards.css');
require('./Css/user.css');

var Elm = require('./Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root);