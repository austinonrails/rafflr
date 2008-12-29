<!--  (* Another free JavaScript © from JavaScript-FX.com *) -->

var oldonload = window.onload;

window.onload = function() { 
	
	if (oldonload) {
    oldonload();
	}
	
	loadScript('JSFX_Browser.js');
	loadScript('JSFX_Layer.js');
	loadScript('JSFX_Fireworks2.js');

}

function loadScript(name) {
	s = document.createElement('script');
  s.setAttribute("type","text/javascript");
  s.setAttribute("src", '/javascripts/' + name);
	document.getElementsByTagName("head")[0].appendChild(s); 
}
