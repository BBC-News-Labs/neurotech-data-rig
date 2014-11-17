"use strict";

var bind = function(ctx, f) {
  if(f.bind) {
    return f.bind(ctx);
  } else {
    return function() { f.apply(ctx, arguments); };
  }
}

var Deja = function() {

};

Deja.prototype = {
  init: function() {
    this._playButton = document.getElementById("play"); 
    this._controls = document.getElementById("controls");
    this._player = document.getElementById("player")
    this._playButton.addEventListener("click",bind(this, this._startPlaying)); 
    this._player.addEventListener("ended", bind(this, this._finishedPlaying));
  },

  _startPlaying: function(event) {
    if(event) event.preventDefault();
    this._player.play(); 
    this._controls.innerHTML="";
  },

  _finishedPlaying: function(event) {
    var remembered = document.createElement("button");
    var notRemembered = document.createElement("button");
    remembered.innerHTML = "I remember this";
    remembered.addEventListener("click", bind(this, this._nextSimilarVideo));
    notRemembered.innerHTML = "I don't remember this";
    notRemembered.addEventListener("click", bind(this, this._nextDissimilarVideo));
    this._controls.appendChild(remembered); 
    this._controls.appendChild(notRemembered);
  },

  _nextSimilarVideo: function(event) {
    event.preventDefault();
    this._nextVideo("similar_to");
  },

  _nextDissimilarVideo: function(event) {
    event.preventDefault(); 
    this._nextVideo("dissimilar_to");
  },

  _nextVideo: function(relationship) {
    var source = this._player.children[0];
    var videoUrl = source.getAttribute("src");
    this._ajaxGet("/videos/" + relationship, { video : videoUrl }, bind(this, function(response) {
      source.setAttribute("src", response);
      this._player.load();
      this._startPlaying();
    }));
  },

  _ajaxGet: function(url, params, callback) {
    var request = new XMLHttpRequest();
    var formattedParams = "";
    for(var k in params) {
      var initialChar = formattedParams === "" ? "?" : "&";
      formattedParams += initialChar + k + "=" + encodeURIComponent(params[k]);
    }
    request.open("GET", url + formattedParams, true);
    request.onreadystatechange = function(event) {
      if(request.readyState == 4) {
        callback(request.responseText);
      }
    };
    request.send();
  }
};

document.addEventListener("DOMContentLoaded", function() {
  var app = new Deja()
  app.init();
});
