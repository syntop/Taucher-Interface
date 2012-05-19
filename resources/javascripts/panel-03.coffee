$ ->
    $compass = $('#compass')
    
    $(window).on 'deviceorientation', (e) ->
        if e.webkitCompassHeading != 0
            $compass.css
                '-webkit-transform': "rotate(-#{e.webkitCompassHeading}deg)"
            location.href = "taucher://compass/#{e.webkitCompassHeading}"
