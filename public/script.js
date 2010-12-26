$.fn.background = function(bg) {
  return $(this).css('backgroundImage', 'url('+bg+')');
}

$.fn.empty_background = function() {
  return $(this).css('backgroundImage', 'none');
}

$(function() {
  function clear() {
    $('#artist').empty();
    $('#album').empty();
    $('#title').empty();
    $('title').html('so nice');
    $('body').empty_background();
  }

  // XHR that updates status every 10 seconds
  function update() {
    setTimeout(function() {
      $.ajax({
        dataType: 'script',
        success: update,
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            clear();
            $('#title').html(errorThrown);
            $('#artist').html(textStatus);
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
