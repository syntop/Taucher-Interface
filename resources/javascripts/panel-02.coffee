$ ->
    touchPointSize = 50
    $(document).on 'tap', '.draggable', (e) ->
        $(this).toggleClass 'active'
    .on 'touchmove', '.draggable', (e) ->
        e.target.style.left = "#{e.touches[0].pageX - touchPointSize/2}px"
        e.target.style.top = "#{e.touches[0].pageY - touchPointSize/2}px"
        
        msg = new Message('/move')
        msg.addInt parseInt($(e.target).text(),10)
        msg.addInt e.touches[0].pageX
        msg.addInt e.touches[0].pageY
        msg.send()
        