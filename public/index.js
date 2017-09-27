require('./index.html');
require('font-awesome/css/font-awesome.css');

var Elm = require('../src/Main.elm');
var mountNode = document.getElementById('app');

var app = Elm.Main.embed(mountNode);
