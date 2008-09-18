window.addEventListener("load", function(e) {
	var launch_div = document.createElement("div");
	launch_div.innerHTML = '<div><a href="">Launch with iKnow!</a></div>';
	document.body.insertBefore(launch_div, $('data-view').firstChild);
}, false);

// Script by dominiek
// email: dterheide@cerego.co.jp
// web: http://developer.iknow.co.jp

// ==UserScript==
// @name          iKnow! Freebase
// @namespace     http://developer.iknow.co.jp/
// @description   Memorize data sets on Freebase.com
// @include       http://www.freebase.com/*
// ==/UserScript==