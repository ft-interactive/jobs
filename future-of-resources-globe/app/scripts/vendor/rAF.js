/*
    THIS FILE HAS BEEN EDITED so the polyfill version of rAF is used in all browsers.

    EXPLANATION:

    Chrome suddenly started showing bizarre animation behaviour, after an update. It was failing to stop animating for some reason - the globe was just spinning continuously, missing its 'destination' and continuing to spin forever, in a wobbly sort of way.
    
    As this was specific to Chrome, which has its own native rAF implementation (not sure if it's webkit-prefixed or not), I suspected this was due to a change in that native implementation. So I have commented out some lines below so that now ALL browsers get the polyfill version of the function (i.e. it sets window.requestAnimationFrame to the homemade polyfill, even if a native version exists).

    Although this is overzealous (I could still use the native implementation on non-Chrome browsers, where available), it doesn't cause any noticeable performance hit, so I'm leaving it like this for now.
*/

// FROM https://gist.github.com/1579671


// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating

// requestAnimationFrame polyfill by Erik Möller
// fixes from Paul Irish and Tino Zijdel

(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    // for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
    //     window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
    //     window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] 
    //                                || window[vendors[x]+'CancelRequestAnimationFrame'];
    // }
 
    // if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
 
    // if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());
