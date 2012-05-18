$ ->
    $(window).on 'devicemotion', (e) ->
        console.log e.data
        return
        x = []
        keys = ['accelerationIncludingGravity', 'rotationRate', 'acceleration', 'webkitCompassHeading']
        for key in keys
            x.push "#{key}: #{e[key]}"
        console.log x.join('<br>')