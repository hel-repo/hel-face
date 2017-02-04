require('./Css/material.min.css');
require('./Css/main.css');
require('./Css/header.css');
require('./Css/cards.css');
require('./Css/user.css');
require('./Css/about.css');

var About = require('./Images/about.png');
var Logo = require('./Images/logo.png');

var Elm = require('./Main.elm');

var root = document.getElementById('root');
Elm.Main.embed(root, { logo: Logo });