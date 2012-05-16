$ ->
    $('a').on 'touchstart', (e) ->
        $(this).addClass('touched')
    .on 'touchend touchmove', (e) ->
        $(this).removeClass('touched')