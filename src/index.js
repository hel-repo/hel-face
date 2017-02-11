require('./Css/material.min.css');
require('./Css/mdl-tweaks.css');
require('./Css/general.css');
require('./Css/header.css');
require('./Css/package.css');
require('./Css/user.css');
require('./Css/about.css');

var About = require('./Images/about.png');
var Logo = require('./Images/logo.png');

var Elm = require('./Main.elm');

var root = document.getElementById('root');
var app = Elm.Main.embed(root, { logo: Logo });

app.ports.title.subscribe(function(title) {
    document.title = title;
});
