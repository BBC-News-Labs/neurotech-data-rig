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
    switch (window.location.pathname) {
      case "/":
        var player = new Deja.Player();
        player.init();
        break;
      case "/related_content":
        var contentList = new Deja.ContentList();
        contentList.init();
        break;
    }
  }
};

Deja.Player = function() {

};

Deja.Player.prototype = {
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


Deja.ContentList = function() {
  this._client = new Faye.Client("/faye");
  this._list = document.getElementById("related_content_items");
  this._template = document.getElementById("related_content_item_template").innerHTML;
};

Deja.ContentList.prototype = {
  init: function() {
    this._masonry =  new Masonry(this._list, {
      itemSelector: 'li',
      gutter: 10
    });
    this._subscribeWikilinks();
    this._subscribeImages();
  },

  _subscribeWikilinks: function() {
    this._client.subscribe("/wikilink", bind(this, function(message) {
      this._appendItem(bind(this, function(element) {
        element.setAttribute("class", "wikilink")
        element.innerHTML = Mustache.render(this._template, message);
      }));
    }));
  },

  _subscribeImages: function() {
    this._client.subscribe("/image", bind(this, function(message) {
      this._appendItem(function(element) {
        element.setAttribute("class", "image")
        var image = document.createElement("img")
        image.setAttribute("src", message.url)
        element.appendChild(image);
      });
    }));
  },

  _appendItem: function(callback) {
    var element = document.createElement("li")
    callback(element)
    window.scrollTo(0,document.body.scrollHeight);
    this._list.appendChild(element);
    this._masonry.appended(element);
    this._masonry.layout();
  }
};

document.addEventListener("DOMContentLoaded", function() {
  var app = new Deja();
  app.init();
});
