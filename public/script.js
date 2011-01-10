$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none');
}

$(function() {
  function clear() {
    $('#artist').empty();
    $('#album').empty();
    $('#title').empty();
    $('title').html('So nice');
    $('body').background();
  }

  // XHR that updates status every 10 seconds
  function update() {
    setTimeout(function() {
      $.ajax({
        dataType: 'script',
        success: update,
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          clear();
          update();
        }
      })
    }, 10 * 1000)
  }
  update()

  // XHR to handle buttons
  $('input').live('click', function(e) {
    var form = $(this).parents('form')
    $.ajax({
      type: form.attr('method'),
      url:  form.attr('action'),
      data: this.name+'='+this.value
    })
    return false
  })
})

$(document).shortkeys({
    'Space':   function () { $.post('player', { playpause: 'a'}); },
    'N':       function () { $.post('player', { next: 'a'}); },
    'P':       function () { $.post('player', { prev: 'a'}); },
    '-':       function () { $.post('player', { voldown: 'a'}); },
    '+':       function () { $.post('player', { volup: 'a'}); }
});
