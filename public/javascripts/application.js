/* Either drop out a user or declare a winner; next_round is the function that gets the next user */
function process(user_id, next_round) { 
  var users = $$('.users');
  var user = $('user_'+user_id);
  Element.removeClassName(user, 'users');
  if (users.length-1 == parseInt($('number_of_winners').value)) {
    dropout(user, declare_winners);
  } else {
    dropout(user, next_round);
  }
}
  
/**
 * Remove a l0z3r and kick off the next round after all the effects are done.
 */
function dropout(element, next_round) {

  /* 
   * Things jump around too much if you put an effect directly on the original so make
   * a copy of it and leave the original hidden, but still displaying, i.e. taking up space.
   */
  var ghost = clone_and_hide(element);
  
  /* Drop out with some random pizazz */
  new Effect.Parallel(
    [
      new Effect.Highlight(ghost),
      new Effect.Highlight($$('#ghost div')[0]),
      dropout_effects[Math.floor(Math.random()*dropout_effects.length)](ghost)
    ].flatten(),
    { 
      afterFinish: function(effect) { 
      	// Even though the effects are supposed to be done here, it looks better to wait a second before
      	// cleaning up and letting the remaining divs float left again.
      	setTimeout(function() { 
      		// Kick off the next round
      		setTimeout(next_round, 1500);
      		Element.hide(element); 
      		Element.remove('ghost'); 
        }, 1000); }
    });
}

function clone_and_hide(element) {
	 /*
    * Prototype's absolutize has problems with margins (see http://dev.rubyonrails.org/ticket/8024)
    * and the fixes didn't work right so positioning this the hard way.
    */
  var offsets = element.positionedOffset();
  var top     = offsets[1];
  var left    = offsets[0];
  var ghost = element.cloneNode(true);
  ghost.id = 'ghost';
  ghost.style.position = 'absolute';
  ghost.style.top = (top - parseFloat(Element.getStyle(element,'margin-top'))) +'px';
  ghost.style.left = (left - parseFloat(Element.getStyle(element,'margin-left'))) + 'px';
  Element.setStyle(element, {'visibility':'hidden'});
  element.parentNode.insertBefore(ghost, element);
  
  return ghost;
}

/* To add additional drop out effects just put another function on this array */
var dropout_effects = 
	[
	  function(element) {
	  	return [
	     new Effect.MoveBy(element, 500, 0, { sync: true }),
	     new Effect.Opacity(element, { sync: true, to: 0.0, from: 1.0 } )
	    ];
	  },
	  function(element) {
	    return new Effect.Shrink(element, { sync: true });
	  },
	  function(element) {
	    return new Effect.Squish(element, { sync: true });
	  },
	  function(element) {
	    return new Effect.Puff(element, { sync: true });
	  },
    function(element) {
      return new Effect.Fold(element, { sync: true });
    }
	];

  
function declare_winners() {
  center_winners();
  start_user_effects();
  start_page_effects();
}

// Move the winners to the middle of the page (there has to be an easier way than this)
function center_winners() {
  Element.addClassName($('users'), "winners");
  var users = $$('.users');
  var width = 0;
  var height = 0;
  users.each(function(user) {
    var dims = Element.getDimensions(user);
    width += dims.width + 15;   // roughly 15 for the margin
    height = Math.max(dims.height, height);
  });
  var viewDims = document.viewport.getDimensions();
  var left = (viewDims.width-width)/2;
  var top = (viewDims.height-height)/2 - height;
  new Effect.Move('users', {x: left, y: top, mode: 'absolute'});
}

// Do crazy stuff to the winners, for now pulse for about 6 seconds
function start_user_effects() {
  setTimeout(function() { 
    $$('.users').each(function(user) { 
      // Queue more effects here if it's not over the top enough already
      new Effect.Pulsate(user, { duration: 10, pulses: 20, queue: { position: 'end', scope: user.id } });
    });
  }, 1000);
}

// Do crazy stuff to the page itself; wait the 6 seconds for the pulse, kill it after 10 seconds
function start_page_effects() {
	if (typeof(JSFX) != 'undefined') {
		setTimeout(function() {
			new Effect.Morph(document.body, { style: { background: '#000'}, duration: 2}); // Nightfall
		  setTimeout(function() {
		    stop_page_effects();
		    JSFX.FireworkDisplay2.running = false;
		  }, 10000);
		  var fireworks = JSFX.FireworkDisplay2(5);
		}, 6000);
	}
}

function stop_page_effects() {
	setTimeout(function() { 
    new Effect.Morph(document.body, { style: { background: '#fff'}, duration: 2}); // Daybreak
    stopMusic(); 
    if ($('new_raffle')) {
      Element.show('new_raffle');
    }
  }, 2000);  
}


/* For testing effects - this will randomly select losers without hitting the server */
function process_client_side() { 
  var users = $$('.users');
  var rand = Math.floor(Math.random()*users.length);
  var user = users[rand];
  Element.removeClassName(user, 'users');
  
  if (users.length-1 == parseInt($('number_of_winners').value)) {
    dropout(user, declare_winners, 1000);
  } else {
    dropout(user, process_client_side, 1000);
  }
}

function playMusic(path_to_song) {
  soundManager.createSound('song', path_to_song);
  soundManager.setVolume('song', 100);
  soundManager.play('song');
}

function stopMusic() {
	var count = 10;
	setTimeout(function() { fadeSong(count); }, 250);
}

function fadeSong(count) {
	soundManager.setVolume('song', count*10); 
	if (count-- <= 0) {
      soundManager.stop('song');
  } else {
    setTimeout(function() { fadeSong(count); }, 500);
  }
}

