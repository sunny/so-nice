/* JavaScript helpers */

// Return a random element from an array.
//  randomItem([3, 9, 8]) # => 5
randomItem = (array) => {
  return array[Math.floor(Math.random() * array.length)]
}

// Change CSS background image.
setBodyBackground = (url) => {
  document.body.style.backgroundImage = url ? `url("${url}")` : "none"
};

// Assigns keyboard keys to buttons.
const initKeyboardShortcuts = () => {
  document.querySelectorAll("[data-key]").forEach(button => {
    const key = button.dataset.key
    document.addEventListener("keypress", e => {
      if (String.fromCharCode(e.charCode) == key) button.click();
    })
  })
}

/* So nice helpers */

// Fetch the MusicBrainz identifier from LastFM's audioscrobbler.
// thanks to @hugovk!
// (https://github.com/hugovk/now-playing-radiator)
function fetchMusicBrainzId(artist) {
  const apiKey = "5636ca9fea36d0323a76638385aab1f3"
  const url =
    'http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getinfo' +
    `&artist=${artist}&api_key=${apiKey}`;
  fetch(url)
    .then(response => response.json())
    .then(data => data.artist.mbid)
}

// Get a new artist image from Last.fm via jsonp
// When found calls the `callback` with the image url as the first argument
function artistImage(artist, callback) {
  if (!artist) return callback();
  cache = artistImage.cache;
  artist = encodeURI(artist);
  const getImageFromCache = () => callback(randomItem(cache[artist]));

  // Deliver from cache
  if (cache.hasOwnProperty(artist)) {
    // execute the callback asynchronously to minimize codepaths
    setTimeout(getImageFromCache, 10);
    return;
  }

  // Load
  fetchMusicBrainzId(mbid => {
    if (!mbid) return;

    const url =
      `https://musicbrainz.org/ws/2/artist/${mbid}?inc=url-rels&fmt=json`;
    fetch(url)
      .then(res => res.json())
      .then(data => {
        const relations = data.relations;
        const commonsStub =
          'https://commons.wikimedia.org/wiki/File:';
        const fileStub =
          'https://commons.wikimedia.org/wiki/Special:Redirect/file/';
        const imagesArr = [];
        for (let i = 0; i < relations.length; i++) {
          if (relations[i].type === 'image') {
            let imageUrl = relations[i].url.resource;
            if (imageUrl.startsWith(commonsStub)) {
              const filename =
                imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
              imageUrl = fileStub + filename;
            }
            imagesArr.push(imageUrl);
          }
        }
        cache[artist] = imagesArr;
        getImageFromCache();
      });
  });
}

artistImage.cache = {};

$(function () {
  // Object that contains all the song info
  const currentSong = {};

  // Update the HTML based on the currentSong object
  function updateInformation(obj) {
    const artistChange = currentSong.artist != obj.artist;
    const songChange = currentSong.title != obj.title;

    currentSong.artist = obj.artist
    currentSong.album = obj.album
    currentSong.title = obj.title
    currentSong.connected = !!obj.connected

    const { artist, album, title, connected } = currentSong

    $('#title').text(title);
    $('#artist').text(artist);
    $('#album').text(album);
    $('[data-sonice-show-if-connected]')[connected ? 'show' : 'hide']();
    $('[data-sonice-hide-if-connected]')[connected ? 'hide' : 'show']();

    if (!title) {
      $('title').text('So nice');
    } else {
      $('title').text(artist + (artist && title ? ' — ' : '') + title);
    }

    if (artistChange || songChange) {
      $('#vote').removeAttr('disabled').show();
    }

    if (artistChange) {
      changeBackground();
    }
  }

  // Change background on the body regularly
  var changeBackground = function () {
    artistImage(currentSong.artist, url => setBodyBackground(url));
  }

  // XHR updating the text regularly
  var update = function () {
    $.ajax({
      dataType: 'json',
      success: updateInformation,
      error: updateInformation
    });
  }

  // XHR overriding the buttons
  $(document).on('click', 'input', function (e) {
    e.preventDefault();

    $.ajax({
      type: 'put',
      url: '/player',
      data: this.name + '=' + encodeURI(this.value),
      complete: update
    });
  });

  // Vote button
  $(document).on('click', '#vote', function () {
    $(this).attr('disabled', true).fadeOut(500);
  });

  update();
  setInterval(update, 500);
  setInterval(changeBackground, 10000);

  initKeyboardShortcuts()
})
