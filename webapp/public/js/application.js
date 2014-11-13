"use strict";

var Deja = function() {

}

Deja.prototype = {
  init: function() {
    var playButton = document.getElementById("play"); 
    var player = document.getElementById("player")
    playButton.addEventListener("click", function(event) {
      event.preventDefault();
      player.play(); 
    }); 
  }
};

document.addEventListener("DOMContentLoaded", function() {
  var app = new Deja()
  app.init();
})
