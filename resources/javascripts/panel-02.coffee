$ ->
    touchPointSize = 50
    $(document).on 'tap', '.draggable', (e) ->
        $(this).toggleClass 'active'
    .on 'touchmove', '.draggable', (e) ->
        console.log "#{$(e.target).text()}: #{e.touches[0].pageX},#{e.touches[0].pageY}"
        e.target.style.left = "#{e.touches[0].pageX - touchPointSize/2}px"
        e.target.style.top = "#{e.touches[0].pageY - touchPointSize/2}px"
        location.href = "taucher://move/#{$(e.target).text()}:#{e.touches[0].pageX}-#{e.touches[0].pageY}"