/* JavaScript helpers */

// Return a random element from an Array
//  [3, 9, 8].random() # => 5
Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

/* jQuery helpers */

// Change CSS background image
$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

// Assigns keyboard keys to elements and adds them to the title attributes
// Needs the data-keyboard-key attribute on elements and optionally accepts
// the data-keyboard-name attribute
$.fn.keyboardShortcut = function() {
  return $(this).each(function() {
    var button = $(this),
    character = $(this).data('key'),
    title = $(this).data('key-name') || character
    button.attr('title', button.attr('title') + ' ('+title+')')
    $(document).keypress(function(e) {
      if (String.fromCharCode(e.charCode) == character)
        button.click()
    })
  })
}


/* So nice helpers */

// Get a new artist image from Last.fm via jsonp
// When found calls the `callback` with the image url as the first argument
function artistImage(artist, callback) {
   if (!artist)
     return callback()
   var cb = function() { callback(cache[artist].random()) },
   cache = artistImage.cache
   artist = encodeURI(artist)

   // Deliver from cache
   if (cache.hasOwnProperty(artist)) {
     // execute the callback asynchronously to minimize codepaths
     setTimeout(cb, 10)
     return
   }

   // Load
   var last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getinfo&artist=%s&api_key=5636ca9fea36d0323a76638385aab1f3"
   $.ajax({
     url: last_fm_uri.replace('%s', artist),
     dataType: 'jsonp',
     success: function(obj) {
       if (obj.artist.image) {
         cache[artist] = $.map(obj.artist.image, function(img) {
           if (img.size == 'mega') {
             return img['#text']
           }
         })
         cb()
       } else {
         callback()
       }
     }
   })
}
artistImage.cache = {}


$(function() {
  // Object that contains all the song info
  var currentSong = {}

  // Update the HTML based on the currentSong object
  function updateInformation(obj) {
    var artistChange = currentSong.artist != obj.artist,
    songChange = currentSong.title != obj.title
    currentSong = obj = obj || {}

    var artist = obj.artist || '',
    album  = obj.album  || '',
    title  = obj.title  || ''

    $('#title' ).text(title)
    $('#artist').text(artist)
    $('#album' ).text(album)

    if (!title)
      $('title').text('So nice')
    else
      $('title').text(artist + (artist && title ? ' — ' : '') + title)

    if (artistChange || songChange)
      $('#vote').removeAttr('disabled').show()

    if (artistChange)
      changeBackground()
  }

  // Change background on the body regularly
  var changeBackground = function(){
    artistImage(currentSong.artist, function(url) {
      $('body').background(url)
    })
  }

  // XHR updating the text regularly
  var update = function() {
    $.ajax({
      dataType: 'json',
      success: updateInformation,
      error:   updateInformation
    })
  }

  // Toggle the playpause button on the remote button widget
  var togglePlayPause = function(toggle_playpause_button){

      if(toggle_playpause_button.parent().hasClass('center-button')){
           if(toggle_playpause_button.hasClass('fa-play')){
              toggle_playpause_button.toggleClass('fa-stop');
           }
           else{
              toggle_playpause_button.toggleClass('fa-play');
           }
      }
  }

  // XHR overriding the buttons
  $(document).on('click', 'input', function(e) {
    e.preventDefault();

    $.ajax({
      type: 'put',
      url: '/player',
      data: this.name+'='+encodeURI(this.value),
      complete: update
    })
  })

  // Vote button
  $(document).on('click', '#vote', function() {
    $(this).attr('disabled', true).fadeOut(500)
  })

  //Show remote control button
  $(document).on('click', '#showremote', function(){
    $('#remote-control').toggle()
  })

  //Now that we have a remote control widget interface, perform the same ajax post operations as the default web interface buttons
  $(document).on('click', '#remote-control nav', function(e){
      e.preventDefault();

      //Should only find one input selector
      var input_selector = $(e.target).find('input');

      //Obviously we're just for one particular input selector here - not multiple!
      if(input_selector.length >1){return;}

      //Animate the playpause icons when playing/pausing music
      var toggle_playpause_button = input_selector.parent();

      togglePlayPause(toggle_playpause_button);

      $.ajax({
          type: 'put',
          url: '/player',
          data: $(input_selector).attr('name')+'='+encodeURI($(input_selector).attr('value')),
          complete: update
      })

  })

 $('#remote-control nav').on('mousedown', function(e){

      console.log("mouse_click here");
      var node = $(this);

      var evt = e || window.event;

      var drag_params = {

           offsetX: node.offset().left,

           offsetY: node.offset().top,

           mouseY: evt.pageY,

           mouseX: evt.pageX

      };

      var e_handlers = {
          mousemove: function(e){

              node.css({
                  left: (drag_params.offsetX + e.pageX - drag_params.mouseX) + 'px',
                  top: (drag_params.offsetY + e.pageY - drag_params.mouseY) + 'px',
                  "z-index": 1000
              });
          },

          mouseup: function(e){
              $(this).off(e_handlers);
          }

      }

      $(this).on(e_handlers);

 });

  update();
  setInterval(update, 500)
  setInterval(changeBackground, 10000)

  // Keyboard shortcuts
  $('input').keyboardShortcut()

})
