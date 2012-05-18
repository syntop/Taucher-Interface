exports = window

$ ->
    exports.console =
        log: (msg) ->
            $('#console').html(msg)
